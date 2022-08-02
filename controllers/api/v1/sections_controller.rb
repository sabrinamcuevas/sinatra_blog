class SectionsController < ApplicationController
  namespace '/sscool/v1/section' do
    post do
      authorized?
      if logged_in?
        return Section.create(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    put do
      authorized?
      if logged_in?
        return Section.update(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    delete '/:id' do
      authorized?
      if logged_in?
        return Section.destroy(data: params)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    get '/sections_by_type' do
      return Section.sections_by_type(data: params)
    end

    get '/list' do
      sections = Section.order(updated_at: :desc)
      { sections: SscoolService.format_list_sections(data: sections), status: :ok }.to_json
    end

    get '/types' do
      { data: SscoolService.types, status: :ok }.to_json
    end

    get '/:id' do
      return Section.show(data: params)
    end
  end
end
