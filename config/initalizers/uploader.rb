# Configure Carrierwave
# CarrierWave.configure do |config|
#   config.root = File.dirname(__FILE__) + '/public'
# end
CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS', # required
    aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"], # required unless using use_iam_profile
    aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"], # required unless using use_iam_profile
    use_iam_profile: false, # optional, defaults to false
    region: 'us-east-1', # optional, defaults to 'us-east-1'
    #host: ENV['AWS_URL'], # optional, defaults to nil
    endpoint: ENV["BASE_URL_AWS"] # optional, defaults to nil
  }
  config.fog_provider = "fog/aws"
  config.fog_directory = ENV["APP_NAME"] # required
  config.fog_public     = false                                                 # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
  #config.cache_storage = :file
end