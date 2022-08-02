Aws::Sesocio::Secrets.setup do |config|
  config.key = ENV["AWS_ACCESS_KEY_ID"]
  config.secret = ENV["AWS_SECRET_ACCESS_KEY"]
  config.environment = ENV["APP_ENV"]
  config.repo_name = ["sscool"]
end