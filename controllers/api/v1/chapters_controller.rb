class ChaptersController < ApplicationController
  namespace '/sscool/v1/chapter' do
    post do
      authorized?
      if logged_in?
        return Chapter.create(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    put do
      authorized?
      if logged_in?
        return Chapter.update(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    delete '/:id' do
      authorized?
      if logged_in?
        return Chapter.destroy(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    get '/list' do
      chapters = Chapter.order(updated_at: :desc)
      { chapters: SscoolService.format_list_chapters(data: chapters), status: :ok }.to_json
    end

    get '/chapters_by_section' do
      return Chapter.chapters_by_section(data: params)
    end

    get '/:id' do
      return Chapter.show(data: params)
    end
  end
end
