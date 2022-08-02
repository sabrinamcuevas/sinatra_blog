class Section < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  has_many :articles
  has_many :images, as: :imageable
  has_many :chapters
  validates :name, :type, :description, presence: true
  enum type: %i[guide cafe_crypto podcast]

  def self.create(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    sections = new(get_params(data))
    if sections.save
      SscoolService.image_process(file: data[:file], object: sections) if data[:file].present?
      { data: SscoolService.format_sections(data: sections), message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(4), status: :unprocessable_entity }.to_json
    end
  end

  def self.show(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    section = Section.find_by(id: data[:id])
    return { message: 'Error, section not found', status: :not_found }.to_json unless section.present?

    { data: SscoolService.format_sections(data: section), message: 'success!', status: :ok }.to_json
  end

  def self.update(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    section = Section.find_by(id: data['id'])
    return { message: 'Error, section not found', status: :not_found }.to_json unless section.present?

    data_section = data.excluding('file')
    if section.update(data_section)
      SscoolService.image_process(file: data[:file], object: section) if data[:file].present?
      { data: SscoolService.format_sections(data: section), message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(5), status: :unprocessable_entity }.to_json
    end
  end

  def self.destroy(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    section = Section.find_by(id: data['id'])
    return { message: 'error!', status: :not_found }.to_json unless section.present?

    section_id = Article.find_by(section_id: data['id'])
    return { message: SscoolErrorHandler.get_error(7), status: :unprocessable_entity }.to_json if section_id.present?

    if section.destroy
      { message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(6), status: :unprocessable_entity }.to_json
    end
  end

  def self.sections_by_type(data:)
    return { error: 'Limit is not a number' }.to_json  if data['limit'].present? && !SscoolService.is_numeric?(data['limit'])
    return { error: 'Offset is not a number' }.to_json if data['offset'].present? && !SscoolService.is_numeric?(data['offset'])
    return { error: 'Limit exceeds maximum' }.to_json if data['limit'].to_i > 50

    offset = data['offset'].present? && data['offset'].to_i > 0 ? data['offset'].to_i : 0
    
    section = Section.where(type: data['type']).order(created_at: :desc).limit(data['limit']).offset(offset)
    
    return { message: 'Error, section not found', status: :not_found }.to_json unless section.present? 

    { data: SscoolService.format_list_sections(data: section), message: 'success!', status: :ok }.to_json
  end

  def self.get_params(data)
    { type: data['type'],
      name: data['name'],
      description: data['description'],
      section_title_id: data['section_title_id'] }
  end
end
