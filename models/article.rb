class Article < ActiveRecord::Base
  belongs_to :section
  belongs_to :chapter
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :images, as: :imageable
  validates :title, :body, :difficulty_level, :section_id, presence: true
  has_many :comments

  def self.create(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    section = Section.find_by(id: data['section_id'])
    return { message: 'Error, section_id no found', status: :not_found }.to_json unless section.present?

    article = new(get_params(data))
    if article.save
      SscoolService.image_process(file: data[:file], object: article) if data[:file].present?
      SscoolService.reading_time(body: data[:body], article: article)
      article.relate_to_tag(tags: data[:tag_ids]) if data[:tag_ids].present?
      { data: SscoolService.format_result_article(data: article), message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(4), status: :unprocessable_entity }.to_json
    end
  end

  def self.update(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    article = Article.find_by(id: data['id'])
    section = Section.find_by(id: data['section_id'])
    return { message: 'Error, section_id no found', status: :not_found }.to_json unless section.present?
    return { message: 'Error, article no found', status: :not_found }.to_json unless article.present?

    data_articles = data.excluding('file', 'tag_ids')
    if article.update(data_articles)
      article.delete_relate_to_tag if data[:tag_ids].present?
      SscoolService.reading_time(body: data[:body], article: article)
      article.relate_to_tag(tags: data[:tag_ids]) if data[:tag_ids].present?
      SscoolService.image_process(file: data[:file], object: article) if data[:file].present?
      { data: SscoolService.format_result_article(data: article), message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(5), status: :unprocessable_entity }.to_json
    end
  end

  def self.destroy(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    article = Article.find_by(id: data[:id])
    return { message: 'Error, article not found', status: :not_found }.to_json unless article.present?

    if article.destroy
      { message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(6), status: :unprocessable_entity }.to_json
    end
  end

  def self.show(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    article = Article.find_by(id: data[:id])
    return { message: 'Error, article not found', status: :not_found }.to_json unless article.present?

    { data: SscoolService.format_result_article(data: article), message: 'success!', status: :ok }.to_json
  end

  def self.list_articles(data:)
    articles = Article.joins(:section).where('section.type' => data['type']).order(published_at: :desc).limit(data['limit'])
    SscoolService.format_result(data: articles)
  end

  def self.articles_by_chapter(data:)
    return { error: 'Limit is not a number' }.to_json  if data['limit'].present? && !SscoolService.is_numeric?(data['limit'])
    return { error: 'Offset is not a number' }.to_json if data['offset'].present? && !SscoolService.is_numeric?(data['offset'])
    return { error: 'Limit exceeds maximum' }.to_json if data['limit'].to_i > 50

    offset = data['offset'].present? && data['offset'].to_i > 0 ? data['offset'].to_i : 0

    articles = Article.where('articles.chapter_id' => data['chapter_id']).order(published_at: :desc).limit(data['limit']).offset(offset)
    return { message: 'Error, article not found', status: :not_found }.to_json unless articles.present?

    { articles: SscoolService.format_result(data: articles), message: 'success!', status: :ok }.to_json
  end

  def relate_to_tag(tags:)
    tags.each do |t|
      tag = Tag.find_by(id: t)
      next if tag.nil?

      taggings = Tagging.new(article_id: id, tag_id: t)
      next if taggings.save
    end
  end

  def delete_relate_to_tag
    taggings = Tagging.where(article_id: id)
    if taggings.present?
      taggings.each do |t|
        t.destroy
      end
    end
  end

  def self.get_params(data)
    { title: data['title'],
      introduction: data['introduction'],
      body: data['body'],
      image_url: data['image_url'],
      difficulty_level: data['difficulty_level'],
      section_id: data['section_id'],
      chapter_id: data['chapter_id'],
      published_at: data['published_at'],
      short_description: data['short_description'],
      article_title_id: data['article_title_id'],
      position: data['position'],
      published: data['published'] }
  end

  def self.get_academy_articles(name:)
    articles = []

    query1 = Article.joins(:tags)
                    .where("tags.name ilike $$%#{name.downcase}%$$")
                    .order('published_at desc')
                    .select(:id, :article_title_id, :title)

    query2 = Article.where("title ilike $$%#{name.downcase}%$$")
                    .order('published_at desc')
                    .select(:id, :article_title_id, :title)

    auxiliar = query1 + query2

    auxiliar.uniq.each { |article| articles << article }

    { articles: articles }
  end
end
