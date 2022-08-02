require 'spec_helper'

RSpec.describe TagsController, type: :request do
  include Rack::Test::Methods

  def app
    App.new
  end

  context 'POST #create' do
    it 'when data is sent' do
      VCR.use_cassette('api_tag_create') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { name: Faker::Lorem.sentence }
        response = post 'sscool/v1/tag', data
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end

    it 'when some items are not shipped' do
      VCR.use_cassette('api_tag_create_2') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { name: '' }
        response = post 'sscool/v1/tag', data
        expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity')
      end
    end
  end

  context 'PUT #update' do
    let!(:tags) { create(:tag) }
    it 'when data is sent' do
      VCR.use_cassette('api_tag_update') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { id: tags.id,
                 name: Faker::Lorem.sentence }
        response = put 'sscool/v1/tag', data
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end

    it 'when some items are not shipped' do
      VCR.use_cassette('api_tag_update_1') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { id: tags.id,
                 name: '' }
        response = put 'sscool/v1/tag', data
        expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity')
      end
    end

    it 'when id tag no exits' do
      VCR.use_cassette('api_tag_update_2') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { id: 788_777,
                 name: Faker::Lorem.sentence }
        response = put 'sscool/v1/tag', data
        expect(JSON.parse(response.body)['status']).to eq('not_found')
      end
    end
  end

  context 'DELETE #destroy' do
    let!(:tags) { create(:tag) }
    it 'when id is sent' do
      VCR.use_cassette('api_tag_delete') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = delete "sscool/v1/tag/#{tags.id}"
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end

    it 'when id is not found' do
      VCR.use_cassette('api_tag_delete_2') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = delete 'sscool/v1/tag/32_320'
        expect(JSON.parse(response.body)['status']).to eq('not_found')
      end
    end
  end

  context 'GET #tags' do
    let!(:tags) { create(:tag) }
    it 'List tags' do
      VCR.use_cassette('api_list_ttags') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = get 'sscool/v1/tag/list'
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end
  end

  context 'error login' do
    let!(:tags) { create(:tag) }
    it 'when create tag' do
      VCR.use_cassette('login_error') do
        token = JsonWebToken.encode({}, Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { comment: Faker::Lorem.sentence }
        response = post 'sscool/v1/tag', data
        expect(JSON.parse(response.body)['error']).to eq('Error, not logged in')
      end
    end

    it 'when update tag' do
      VCR.use_cassette('login_error_update') do
        token = JsonWebToken.encode({}, Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { comment: Faker::Lorem.sentence }
        response = put 'sscool/v1/tag', data
        expect(JSON.parse(response.body)['error']).to eq('Error, not logged in')
      end
    end

    it 'when delete tag' do
      VCR.use_cassette('login_error_delete') do
        token = JsonWebToken.encode({}, Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = delete "sscool/v1/tag/#{tags.id}"
        expect(JSON.parse(response.body)['error']).to eq('Error, not logged in')
      end
    end
  end
end
