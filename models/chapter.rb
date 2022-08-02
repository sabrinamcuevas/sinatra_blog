class Chapter < ActiveRecord::Base
  has_many :articles
  has_many :images, as: :imageable
  validates :name, :description, :section_id, presence: true
  belongs_to :section
  
  def self.create(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    chapters = new(get_params(data))
    section = Section.find_by(id: data['section_id'])
    return { message: 'Error, section_id no found', status: :not_found }.to_json unless section.present?

    if chapters.save
      SscoolService.image_process(file: data[:file], object: chapters) if data[:file].present?
      { data: SscoolService.format_chapters(data: chapters), message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(4), status: :unprocessable_entity }.to_json
    end
  end

  def self.show(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    chapter = Chapter.find_by(id: data[:id])
    return { message: 'Error, chapter not found', status: :not_found }.to_json unless chapter.present?

    { data: SscoolService.format_chapters(data: chapter), message: 'success!', status: :ok }.to_json
  end

  def self.update(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    chapter = Chapter.find_by(id: data['id'])
    section = Section.find_by(id: data['section_id'])
    return { message: 'Error, section or chapter not found', status: :not_found }.to_json unless chapter.present? && section.present?

    data_chapter = data.excluding('file')
    if chapter.update(data_chapter)
      SscoolService.image_process(file: data[:file], object: chapter) if data[:file].present?
      { data: SscoolService.format_chapters(data: chapter), message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(5), status: :unprocessable_entity }.to_json
    end
  end

  def self.destroy(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    chapter = Chapter.find_by(id: data['id'])
    return { message: 'Error, chapter not found', status: :not_found }.to_json unless chapter.present?

    chapter_id = Article.where(chapter_id: data['id'])
    return { message: SscoolErrorHandler.get_error(8), status: :unprocessable_entity }.to_json if chapter_id.present?

    if chapter.destroy
      { message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(6), status: :unprocessable_entity }.to_json
    end
  end

  def self.chapters_by_section(data:)
    return { error: 'Limit is not a number' }.to_json  if data['limit'].present? && !SscoolService.is_numeric?(data['limit'])
    return { error: 'Offset is not a number' }.to_json if data['offset'].present? && !SscoolService.is_numeric?(data['offset'])
    return { error: 'Limit exceeds maximum' }.to_json if data['limit'].to_i > 50

    offset = data['offset'].present? && data['offset'].to_i > 0 ? data['offset'].to_i : 0

    chapters = Chapter.where(section_id: data['section_id']).order(created_at: :desc).limit(data['limit']).offset(offset)
    return { message: 'Error, section not found', status: :not_found }.to_json unless chapters.present?

    { data: SscoolService.format_list_chapters(data: chapters), message: 'success!', status: :ok }.to_json
  end

  def self.get_params(data)
    { section_id: data['section_id'],
      name: data['name'],
      description: data['description'],
      position: data['position'],
      chapter_title_id: data['chapter_title_id']
    }
  end
end
