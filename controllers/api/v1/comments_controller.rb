class CommentsController < ApplicationController
  namespace '/sscool/v1/comment' do
    post do
      authorized?
      if logged_in?
        unless params['comment'].present?
          return halt 422,
                      { error: 'Error, no comment was sent',
                        status: :unprocessable_entity }.to_json
        end

        return Comment.create(data: params, user: current_user)
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    get '/list' do
      if logged_in?
        comments = Comment.order(id: :asc)
        { comments: comments }.to_json
      else
        halt 401,
             { 'Content-Type' => 'application/json' },
             { error: 'Error, not logged in' }.to_json
      end
    end

    get '/get_article_comments' do
      authorized?
      if logged_in?
        comments = Comment.get_article_comments(params, current_user).to_json
        return comments
      else
        halt 401,
            { 'Content-Type' => 'application/json' },
            { error: 'Error, not logged in' }.to_json
      end
    end

    get '/get_count' do
        count = Comment.get_count_total(params).to_json
        return count
    end

    

  end
end
