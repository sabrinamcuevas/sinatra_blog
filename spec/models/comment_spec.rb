require 'spec_helper'

RSpec.describe Comment do
  include Rack::Test::Methods

  let(:current_user) { User.find(21) }

  describe '#comment!' do
    context 'when the comment is sent' do
      it 'when the comment is no sent' do
        data = { 'comment' => Faker::Lorem.sentence }
        result = Comment.create(data: data, user: current_user)
        expect(JSON.parse(result)['status']).to eq('ok')
      end

      it 'when the comment is no sent' do
        data = { 'comment' => '' }
        result = Comment.create(data: data, user: current_user)
        expect(JSON.parse(result)['status']).to eq('unprocessable_entity')
      end

      it 'when the comment is not the correct size (5 - 1024)' do
        data = { 'comment' => 'asd' }
        result = Comment.create(data: data, user: current_user)
        expect(JSON.parse(result)['status']).to eq('unprocessable_entity')
      end
    end
  end
end
