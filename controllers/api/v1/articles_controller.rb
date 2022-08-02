class ArticlesController < ApplicationController
  namespace '/sscool/v1/article' do
    post do
      authorized?
      if logged_in?
        return Article.create(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    put do
      authorized?
      if logged_in?
        return Article.update(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    delete '/:id' do
      authorized?
      if logged_in?
        return Article.destroy(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    get '/list' do
      unless params['type'].present?
        return halt 422,
                    { error: 'Error, no type was sent',
                      status: :unprocessable_entity }.to_json
      end

      articles = Article.list_articles(data: params)
      { articles: articles, status: :ok }.to_json
    end

    get '/search_by' do
      return unless params['name'].present?

      articles_array = Article.get_academy_articles( name: params['name']).to_json

      return articles_array
    end

    get '/articles_by_chapter' do
      return Article.articles_by_chapter(data: params)
    end

    get '/:id' do
      return Article.show(data: params)
    end
  end
end
