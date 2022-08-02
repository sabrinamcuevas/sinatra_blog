require 'spec_helper'

RSpec.describe ChaptersController, type: :request do
  include Rack::Test::Methods

  def app
    App.new
  end

  context 'POST #create' do
    let!(:sections) { create(:section) }

    it 'when data is sent' do
      VCR.use_cassette('api_chapter_create') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { description: Faker::Lorem.paragraph,
                 name: Faker::Lorem.sentence,
                 section_id: sections.id,
                 file: 'data:image/png;base64,' + Base64.encode64(File.open('spec/fixtures/article.png', 'rb').read)
               }
        response = post 'sscool/v1/chapter', data
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end

    it 'when some items are not shipped' do
      VCR.use_cassette('api_chapter_create_2') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { description: '',
                 name: Faker::Lorem.sentence,
                 section_id: sections.id }
        response = post 'sscool/v1/chapter', data
        expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity')
      end
    end

    it 'when some section_id no found' do
      VCR.use_cassette('api_chapter_create_2') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { description: Faker::Lorem.paragraph,
                 name: Faker::Lorem.sentence,
                 section_id: '' }
        response = post 'sscool/v1/chapter', data
        expect(JSON.parse(response.body)['status']).to eq('not_found')
      end
    end
  end

  context 'PUT #update' do
    let!(:chapters) { create(:c_podcast) }
    let!(:sections) { create(:section) }

    it 'when data is sent' do
      VCR.use_cassette('api_chapter_update') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { id: chapters.id,
                 description: Faker::Lorem.paragraph,
                 name: Faker::Lorem.sentence,
                 section_id: sections.id,
                 file: 'data:image/png;base64,' + Base64.encode64(File.open('spec/fixtures/article.png', 'rb').read)
               }
        response = put 'sscool/v1/chapter', data
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end

    it 'when some items are not shipped' do
      VCR.use_cassette('api_chapter_update_1') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { id: chapters.id,
                 description: '',
                 name: Faker::Lorem.sentence,
                 section_id: sections.id }
        response = put 'sscool/v1/chapter', data
        expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity')
      end
    end

    it 'when id chapter no exits' do
      VCR.use_cassette('api_chapter_update_2') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { id: 788_777,
                 description: Faker::Lorem.paragraph,
                 name: Faker::Lorem.sentence,
                 section_id: sections.id }
        response = put 'sscool/v1/chapter', data
        expect(JSON.parse(response.body)['status']).to eq('not_found')
      end
    end
  end

  context 'DELETE #destroy' do
    let!(:chapters) { create(:c_podcast) }
    it 'when id is sent' do
      VCR.use_cassette('api_chapter_delete') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = delete "sscool/v1/chapter/#{chapters.id}"
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end

    it 'when id is not found' do
      VCR.use_cassette('api_chapter_delete_2') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = delete 'sscool/v1/chapter/32_320'
        expect(JSON.parse(response.body)['status']).to eq('not_found')
      end
    end
  end

  context 'GET #chapters' do
    let!(:chapters) { create(:c_podcast) }
    it 'List chapters' do
      VCR.use_cassette('api_list_chapters') do
        token = JsonWebToken.encode({ user_id: 21, email: 'admin@sesocio.com', role: 'admin' },
                                    Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = get 'sscool/v1/chapter/list'
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end
  end

  context 'error login' do
    let!(:chapters) { create(:c_podcast) }
    it 'when create chapter' do
      VCR.use_cassette('login_error') do
        token = JsonWebToken.encode({}, Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { comment: Faker::Lorem.sentence }
        response = post 'sscool/v1/chapter', data
        expect(JSON.parse(response.body)['error']).to eq('Error, not logged in')
      end
    end

    it 'when update chapter' do
      VCR.use_cassette('login_error_update') do
        token = JsonWebToken.encode({}, Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        data = { comment: Faker::Lorem.sentence }
        response = put 'sscool/v1/chapter', data
        expect(JSON.parse(response.body)['error']).to eq('Error, not logged in')
      end
    end

    it 'when delete chapter' do
      VCR.use_cassette('login_error_delete') do
        token = JsonWebToken.encode({}, Time.now.to_i + 24.hours.to_i)
        header 'authorization', token.to_s
        response = delete "sscool/v1/chapter/#{chapters.id}"
        expect(JSON.parse(response.body)['error']).to eq('Error, not logged in')
      end
    end
  end
end
