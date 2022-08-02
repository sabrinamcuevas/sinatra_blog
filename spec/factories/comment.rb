FactoryBot.define do
  factory :comment do |f|
    f.user_id                         { 152_036 }
    f.comment                         { Faker::Lorem.sentence }
    f.firstname                       { Faker::Name.first_name }
    f.lastname                        { Faker::Name.last_name }
    f.email                           { Faker::Internet.safe_email }
    f.created_at                      { Time.now }
    f.updated_at                      { Time.now }
  end
end
