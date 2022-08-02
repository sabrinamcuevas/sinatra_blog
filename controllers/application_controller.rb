require 'sinatra/namespace'

class ApplicationController < Sinatra::Base
  register Sinatra::Namespace
  register Sinatra::ActiveRecordExtension

  set :default_content_type, 'application/json'

  configure do
    enable :cross_origin
  end

  before do
    return true if request.request_method == 'OPTIONS'
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  options '*' do
    response.headers['Allow'] = 'GET, PUT, POST, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = '*'
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
    200
  end

  get '/health' do
    return { status: 200 }.to_json
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= Core::Auth.user.present? ? User.find(Core::Auth.user) : nil
    end

    def authorized?
      unless Core::Auth.authenticate!(request.env['HTTP_AUTHORIZATION'], request.ip)
        halt 404,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, invalid API key' }.to_json
      end
    end
  end
end
