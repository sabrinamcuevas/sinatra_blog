FactoryBot.define do
  factory :user_article do |f|
    f.association                     :article
    f.association                     :user
    f.type                            { Faker::Number.within(range: 0..2) }
    f.name                            { Faker::Lorem.sentence }
    f.reading_percentage              { Faker::Number.decimal(l_digits: 2) }
    f.read                            { Faker::Boolean.boolean }
    f.created_at                      { Time.now }
    f.updated_at                      { Time.now }
  end
end
