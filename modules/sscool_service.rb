module SscoolService
  def self.on?
    ENV['SSCOOL_ON'] == 'true'
  end

  def self.format_result_article(data:)
    articles = []
    if data.present?
      articles.push({
                      id: data['id'],
                      section_id: data['section_id'],
                      chapter_id: data['chapter_id'],
                      body: data['body'].present? ? JSON.parse(data['body']) : '',
                      title: data['title'].present? ? JSON.parse(data['title']) : '',
                      published: data['published'],
                      reading_time: data['reading_time'],
                      position: data['position'],
                      published_at: data['published_at'],
                      created_at: data['created_at'],
                      updated_at: data['updated_at'],
                      image_url: data['image_url'].present? ? JSON.parse(data['image_url']) : '',
                      new: is_new(id: data['id']),
                      difficulty_level: data['difficulty_level'],
                      introduction: data['introduction'].present? ? JSON.parse(data['introduction']) : '',
                      short_description: data['short_description'],
                      article_title_id: data['article_title_id'].present? ? JSON.parse(data['article_title_id']) : '',
                      tag_ids: get_tags(id: data['id'])
                    })
    end
    articles
  end

  def self.get_tags(id:)
    tag_ids = []
    tags = Tagging.where(article_id: id)
    tags.each do |t|
      tag_ids << t.tag_id
    end
    tag_ids
  end

  def self.format_result(data:)
    articles = []
    if data.present?
      data.each do |d|
        articles.push({
                        id: d.id,
                        section_id: d.section_id,
                        chapter_id: d.chapter_id,
                        body: d.body.present? ? JSON.parse(d.body) : '',
                        title: d.title.present? ? JSON.parse(d.title) : '',
                        published: d.published,
                        reading_time: d.reading_time,
                        position: d.position,
                        published_at: d.published_at,
                        created_at: d.created_at,
                        updated_at: d.updated_at,
                        image_url: d.image_url.present? ? JSON.parse(d.image_url) : '',
                        new: is_new(id: d.id),
                        difficulty_level: d.difficulty_level,
                        introduction: d.introduction.present? ? JSON.parse(d.introduction) : '',
                        short_description: d.short_description,
                        article_title_id: d.article_title_id.present? ? JSON.parse(d.article_title_id) : '',
                        tag_ids: get_tags(id: d.id)
                      })
      end
    end
    articles
  end

  def self.format_list_sections(data:)
    sections = []
    if data.present?
      data.each do |d|
        #t = JSON.parse(d.image_url)
        t =  presigned_url('image20220113-38341-fysgt8.png')
        debugger
        sections.push({
                        id: d.id,
                        name: d.name,
                        type: d.type,
                        description: d.description,
                        image_url: d.image_url.present? ? JSON.parse(d.image_url) : '',
                        section_title_id: d.section_title_id,
                        created_at: d.created_at,
                        updated_at: d.updated_at
                      })
      end
    end
    sections
  end

  def self.format_sections(data:)
    sections = []
    if data.present?
      sections.push({
                      id: data['id'],
                      name: data['name'],
                      type: data['type'],
                      description: data['description'],
                      image_url: data['image_url'].present? ? JSON.parse(data['image_url']) : '',
                      section_title_id: data['section_title_id'],
                      created_at: data['created_at'],
                      updated_at: data['updated_at']
                    })
    end
    sections
  end

  def self.format_list_chapters(data:)
    chapters = []
    if data.present?
      data.each do |d|
        chapters.push({
                        id: d.id,
                        section_id: d.section_id,
                        name: d.name,
                        position: d.position,
                        description: d.description,
                        image_url: d.image_url.present? ? JSON.parse(d.image_url) : '',
                        chapter_title_id: d.chapter_title_id,
                        created_at: d.created_at,
                        updated_at: d.updated_at
                      })
      end
    end
    chapters
  end

  def self.format_chapters(data:)
    chapters = []
    if data.present?
      chapters.push({
                      id: data['id'],
                      section_id: data['section_id'],
                      name: data['name'],
                      position: data['position'],
                      description: data['description'],
                      image_url: data['image_url'].present? ? JSON.parse(data['image_url']) : '',
                      chapter_title_id: data['chapter_title_id'],
                      created_at: data['created_at'],
                      updated_at: data['updated_at'],
                      count_articles: Article.where(chapter_id: data['id'] ).count
                    })
    end
    chapters
  end

  def self.types
    types = []

    types << {
      type: 'guide',
      title: 'Guía',
      description: 'Todo lo que necesitas saber sobre criptomonedas, finanzas y más para volverte un experto.'
    }

    types << {
      type: 'cafe_crypto',
      title: 'Todo sobre Cripto',
      description: 'Todo lo que necesitas saber sobre criptomonedas, finanzas y más para volverte un experto.'
    }

    types << {
      type: 'podcast',
      title: 'Podcast',
      description: 'Disfrutá de los episodios de #LaLibertadDeTusFinanzas y aprendé escuchando.'
    }
  end

  def self.image_process(file:, object:)
    uploader = ImagesUploader.new
    file = base64_to_file(file)
    uploader.store!(file)
    object.image_url = { "large": uploader.large.url, "small": uploader.small.url, "medium": uploader.medium.url, "thumbnail": uploader.thumb.url }.to_json
    object.save
  end

  def self.base64_to_file(base64)
    aux = base64.split(',')
    encoded_file = aux[1]
    ext = aux[0].split(/[\/,\;]/)[1]
    decoded_file = Base64.decode64(encoded_file)
    file = Tempfile.new(['image', ".#{ext}"])
    file.binmode
    file.write decoded_file
    file
  end

  def self.reading_time(body:, article:)
    content = JSON.parse(body)['es']
    words_per_minute = 200 # en español
    text = Nokogiri::HTML(content).at('body').inner_text
    article.reading_time = (text.scan(/\w+/).length / words_per_minute).to_i == 0 ? 1 : (text.scan(/\w+/).length / words_per_minute).to_i
    article.save
  end

  def self.is_new(id:)
    article = Article.find_by(id: id)
    return false if article.published_at.nil?

    published = article.published_at.strftime('%F')
    published_plus_seven = (article.published_at + 7.days).strftime('%F')
    today = Time.now.strftime('%F')
    published <= today && today <= published_plus_seven
  end

  def self.to_slug(param)
    ret = param.strip.downcase
    ret.gsub! /['`]/, ""
    ret.gsub! /\s*@\s*/, ""
    ret.gsub! /\s*&\s*/, ""
    ret.gsub! /\s*[^A-Za-z0-9\.]\s*/, '-'
    ret.gsub! /[-_]{2,}/, '-'
    ret.gsub! /-+/, "-"
    ret.gsub! /\A[-\.]+|[-\.]+\z/, ""
    ret
  end

  def self.is_numeric?(obj)
    obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  def self.presigned_url(image_name)
    Fog::AWS::Storage.new(
      aws_access_key_id: "AKIAINIFARMWB4Q5QYRQ",
      aws_secret_access_key: "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",
    ).put_object_url('sesocio',
      'assets/admin/sscool/photos/' + image_name,
      5.minutes.from_now
      #5.min
    )
  end

end
