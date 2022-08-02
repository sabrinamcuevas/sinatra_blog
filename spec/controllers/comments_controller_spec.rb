require 'spec_helper'

RSpec.describe CommentsController, type: :request do
  include Rack::Test::Methods

  def app
    App.new
  end

  context 'POST #create' do
    it 'when comment is sent' do
      VCR.use_cassette('api_comment') do
        token = JsonWebToken.encode({ user_id: 152_036, email: 'ivana.moyano@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { comment: Faker::Lorem.sentence }
        response = post 'sscool/v1/comment', data
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end

    it 'when comment is sent' do
      VCR.use_cassette('api_comment_2') do
        token = JsonWebToken.encode({ user_id: 152_036, email: 'ivana.moyano@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = post 'sscool/v1/comment'
        expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity')
      end
    end
  end

  context 'GET #list_comments' do
    let!(:comments) { create(:comment) }
    it 'full list of comments' do
      VCR.use_cassette('api_list_comments') do
        token = JsonWebToken.encode({ user_id: 152_036, email: 'ivana.moyano@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = get 'sscool/v1/comment/list'
        expect(JSON.parse(response.body)['comments'][0].to_json).to eq(comments.to_json)
      end
    end
  end

  context 'error login' do
    it 'when create comments' do
      VCR.use_cassette('login_error') do
        token = JsonWebToken.encode({}, Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { comment: Faker::Lorem.sentence }
        response = post 'sscool/v1/comment', data
        expect(JSON.parse(response.body)['error']).to eq('Error, not logged in')
      end
    end

    it 'when create list comments' do
      VCR.use_cassette('login_error') do
        token = JsonWebToken.encode({}, Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = get 'sscool/v1/comment/list'
        expect(JSON.parse(response.body)['error']).to eq('Error, not logged in')
      end
    end
  end
end
