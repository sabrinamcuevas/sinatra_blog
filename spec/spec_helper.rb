ENV['APP_ENV'] = 'test'
require  'simplecov'

SimpleCov.start do
  add_filter "/lib/"
  add_filter "/spec/"
end

require "#{Dir.pwd}/api.rb"
require 'rack/test'
require 'support/factory_bot'
require 'vcr'
require 'faker'
require 'database_cleaner/active_record'
require 'jwt'

load "#{Dir.pwd}/test_variables.rb"

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation  # clean DB of any leftover data
    DatabaseCleaner.strategy = :transaction # rollback transactions between each test
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.filter_run :focus => true
  conf.run_all_when_everything_filtered = true
end

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

