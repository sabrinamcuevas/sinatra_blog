class TagsController < ApplicationController
  namespace '/sscool/v1/tag' do
    post do
      authorized?
      if logged_in?
        return Tag.create(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    put do
      authorized?
      if logged_in?
        return Tag.update(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    delete '/:id' do
      authorized?
      if logged_in?
        return Tag.destroy(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    get '/list' do
      return Tag.list(data: params)
    end

    get '/:id' do
      return Tag.show(data: params)
    end
  end
end
