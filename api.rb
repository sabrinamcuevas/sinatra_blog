require 'bundler/setup'
require 'sinatra/base'
require 'rake'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'sinatra/contrib'
require 'i18n'
require 'json'
require 'date'
require 'sinatra/namespace'
require 'jwt'
require 'rack/contrib'
require 'faraday'
require 'factory_bot_rails'
require 'pry'
require 'byebug'
require 'sinatra/cors'
require 'sinatra/cross_origin'
require 'aws/sesocio/secrets'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'fog-aws'
require 'activerecord-import'


ENV['APP_ENV'] ||= 'development'

Dir["#{Dir.pwd}/config/initalizers/*.rb"].each { |file| require file }

if ENV['APP_ENV'] != 'test' && ENV['APP_ENV'] != 'development'
  Aws::Sesocio::Secrets.get_parameters("sscool-parameter")
  Aws::Sesocio::Secrets.get_secrets("sscool")
else
  Dir["#{Dir.pwd}/#{ENV['APP_ENV']}_variables.rb"].each { |file| load file }
end

Dir["#{Dir.pwd}/controllers/*.rb"].each { |file| require file }

Dir["#{Dir.pwd}/controllers/api/v1/*.rb"].each { |file| require file }

Dir["#{Dir.pwd}/modules/*.rb"].each { |file| require file }

Dir["#{Dir.pwd}/models/*.rb"].each { |file| require file }

Dir["#{Dir.pwd}/lib/*.rb"].each { |file| require file }

Dir["#{Dir.pwd}/utils/*.rb"].each { |file| require file }



set :env, ENV['APP_ENV'].to_sym
set :database, ENV['DATABASE_URL']

I18n.config.available_locales = :en

class App < Sinatra::Base
  use ArticlesController
  use ChaptersController
  use CommentsController
  use SectionsController
  use TagsController

  def self.set_cache(key, value, time)
    settings.dc.set(key, value, time)
    value
  end
end
