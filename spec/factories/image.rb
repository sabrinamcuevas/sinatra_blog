FactoryBot.define do
    factory :image do |f|
      f.name                            { Faker::CryptoCoin.coin_name }
      f.created_at                      { Time.now }
      f.updated_at                      { Time.now }
    end
  end