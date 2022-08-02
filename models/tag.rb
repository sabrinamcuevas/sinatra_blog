class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :articles, through: :taggings
  validates :name, presence: true, uniqueness: true
  def self.create(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    tags = new(get_params(data))
    if tags.save
      { data: tags, message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(4), status: :unprocessable_entity }.to_json
    end
  end

  def self.show(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    tag = Tag.find_by(id: data[:id])
    return { message: 'Error, tag not found', status: :not_found }.to_json unless tag.present?

    { data: tag, message: 'success!', status: :ok }.to_json
  end

  def self.update(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    tag = Tag.find_by(id: data['id'])
    return { message: 'Error, tag not found', status: :not_found }.to_json unless tag.present?

    if tag.update(data)
      { data: tag, message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(5), status: :unprocessable_entity }.to_json
    end
  end

  def self.destroy(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    tag = Tag.find_by(id: data['id'])
    return { message: 'Error, tag not found', status: :not_found }.to_json unless tag.present?

    if tag.destroy
      { message: 'success!', status: :ok }.to_json
    else
      { message: SscoolErrorHandler.get_error(6), status: :unprocessable_entity }.to_json
    end
  end

  def self.list(data:)
    return { message: SscoolErrorHandler.get_error(3), error_code: 3 }.to_json unless SscoolService.on?

    tags = []
    data['tag_ids'].each do |d|
      tag = Tag.find_by(id: d)
      return { message: 'Error, tag not found', status: :not_found }.to_json unless tag.present?

      tags << {
        id: tag.id,
        name: tag.name
      }
    end
    { tags: tags, status: :ok }.to_json
  end

  def self.get_params(data)
    { name: data['name'] }
  end
end
