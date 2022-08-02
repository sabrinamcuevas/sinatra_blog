require 'spec_helper'

RSpec.describe SectionsController, type: :request do
  include Rack::Test::Methods

  def app
    App.new
  end

  context 'POST #create' do
    it 'when data is sent' do
      VCR.use_cassette('api_section_create') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { type: 'podcast',
                 name: Faker::Lorem.sentence,
                 description: Faker::Lorem.paragraph,
                 file: 'data:image/png;base64,' + Base64.encode64(File.open('spec/fixtures/article.png', 'rb').read)
               }
        response = post 'sscool/v1/section', data
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end

    it 'when some items are not shipped' do
      VCR.use_cassette('api_section_create_2') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { type: '',
                 name: Faker::Lorem.sentence,
                 description: '' }
        response = post 'sscool/v1/section', data
        expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity')
      end
    end
  end

  context 'PUT #update' do
    let!(:sections) { create(:section) }
    it 'when data is sent' do
      VCR.use_cassette('api_section_update') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { id: sections.id,
                 type: 'podcast',
                 name: Faker::Lorem.sentence,
                 description: Faker::Lorem.paragraph }
        response = put 'sscool/v1/section', data
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end

    it 'when some items are not shipped' do
      VCR.use_cassette('api_section_update_1') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { id: sections.id,
                 type: '',
                 name: Faker::Lorem.sentence,
                 description: '' }
        response = put 'sscool/v1/section', data
        expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity')
      end
    end

    it 'when id section no exits' do
      VCR.use_cassette('api_section_update_2') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { id: 788_777,
                 type: 'podcast',
                 name: Faker::Lorem.sentence,
                 description: Faker::Lorem.paragraph }
        response = put 'sscool/v1/section', data
        expect(JSON.parse(response.body)['status']).to eq('not_found')
      end
    end
  end

  context 'DELETE #destroy' do
    let!(:sections) { create(:section) }
    it 'when id is sent' do
      VCR.use_cassette('api_section_delete') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = delete "sscool/v1/section/#{sections.id}"
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end

    it 'when id is not found' do
      VCR.use_cassette('api_section_delete_2') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = delete 'sscool/v1/section/32_320'
        expect(JSON.parse(response.body)['status']).to eq('not_found')
      end
    end
  end

  context 'GET #sections' do
    let!(:sections) { create(:section) }
    it 'List sections' do
      VCR.use_cassette('api_list_sections') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = get 'sscool/v1/section/list'
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end
  end

  context 'error login' do
    let!(:sections) { create(:section) }
    it 'when create section' do
      VCR.use_cassette('login_error') do
        token = JsonWebToken.encode({}, Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { comment: Faker::Lorem.sentence }
        response = post 'sscool/v1/section', data
        expect(JSON.parse(response.body)['error']).to eq('Error, not logged in')
      end
    end

    it 'when update section' do
      VCR.use_cassette('login_error_update') do
        token = JsonWebToken.encode({}, Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { comment: Faker::Lorem.sentence }
        response = put 'sscool/v1/section', data
        expect(JSON.parse(response.body)['error']).to eq('Error, not logged in')
      end
    end

    it 'when delete section' do
      VCR.use_cassette('login_error_delete') do
        token = JsonWebToken.encode({}, Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = delete "sscool/v1/section/#{sections.id}"
        expect(JSON.parse(response.body)['error']).to eq('Error, not logged in')
      end
    end
  end
end
