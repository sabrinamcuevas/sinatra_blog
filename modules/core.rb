require 'faraday'
require 'json'

module Core
  autoload :Request, "#{File.dirname(__FILE__)}/core/request.rb"
  autoload :Auth, "#{File.dirname(__FILE__)}/core/auth.rb"
  autoload :Aes, "#{File.dirname(__FILE__)}/core/aes.rb"

  def self.authenticated_header
    secret = ENV['API_CORE_KEY']
    payload = { 'application_name' => 'community-sscool' }
    payload[:exp] = 30.minutes.from_now.to_i

    JWT.encode(payload, secret)
  end

  def self.make_request(type, url:, data: nil)
    response = Request.send(type, url, data)
    JSON.parse(response.body)
  rescue StandardError => e
    puts e.to_s
    { status: :unprocessable_entity, error: e.to_s }
  end
end
