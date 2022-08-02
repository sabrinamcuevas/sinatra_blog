FactoryBot.define do
  factory :article do |f|
    f.chapter_id                      { Faker::Number.within(range: 1..4) }
    f.introduction                    { Faker::Lorem.paragraph }
    f.body                            { Faker::Lorem.paragraph }
    f.title                           { Faker::Lorem.sentence }
    f.image_url                       { '{"large": "https://sesocio.s3.amazonaws.com/assets/admin/sscool/photos/large_image20220124-14-952xpd.png?X-Amz-Expires=600\u0026X-Amz-Date=20220124T142644Z\u0026X-Amz-Algorithm=AWS4-HMAC-SHA256\u0026X-Amz-Credential=AKIAINIFARMWB4Q5QYRQ%2F20220124%2Fus-east-1%2Fs3%2Faws4_request\u0026X-Amz-SignedHeaders=host\u0026X-Amz-Signature=c1f778358fb914b4c57dac35a5d3e5866da37f57337bfb7e0d7dfd805a988c1a"}' }
    f.new                             { false }
    f.reading_time                    { Faker::Number.within(range: 1..20) }
    f.position                        { Faker::Number.within(range: 1..10) }
    f.difficulty_level                { Faker::Number.within(range: 1..3) }
    f.published                       { Time.now }
    f.published_at                    { Time.now }
    f.short_description               { Faker::Lorem.paragraph }
    f.article_title_id                { Faker::Lorem.sentence }
    f.created_at                      { Time.now }
    f.updated_at                      { Time.now }

    trait :type_guide do |g|
      g.section_id { 1 }
    end

    trait :type_cafe_crypto do |g|
      g.section_id { 2 }
    end

    trait :type_podcast do |g|
      g.section_id { 3 }
    end

    factory :cafe_crypto, traits: [:type_cafe_crypto]
    factory :podcast, traits: [:type_podcast]
    factory :guide, traits: [:type_guide]
  end
end
