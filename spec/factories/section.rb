FactoryBot.define do
  factory :section do |f|
    f.name                            { Faker::Lorem.sentence }
    f.description                     { Faker::Lorem.paragraph }
    f.image_url                       { '{"large": "https://sesocio.s3.amazonaws.com/assets/admin/sscool/photos/large_image20220124-14-952xpd.png?X-Amz-Expires=600\u0026X-Amz-Date=20220124T142644Z\u0026X-Amz-Algorithm=AWS4-HMAC-SHA256\u0026X-Amz-Credential=AKIAINIFARMWB4Q5QYRQ%2F20220124%2Fus-east-1%2Fs3%2Faws4_request\u0026X-Amz-SignedHeaders=host\u0026X-Amz-Signature=c1f778358fb914b4c57dac35a5d3e5866da37f57337bfb7e0d7dfd805a988c1a"}' }
    f.created_at                      { Time.now }
    f.updated_at                      { Time.now }

    trait :type_guide do |g|
      g.type { 'guide' }
    end

    trait :type_cafe_crypto do |g|
      g.type { 'cafe_crypto' }
    end

    trait :type_podcast do |g|
      g.type { 'podcast' }
    end

    factory :s_cafe_crypto, traits: [:type_cafe_crypto]
    factory :s_podcast, traits: [:type_podcast]
    factory :s_guide, traits: [:type_guide]
  end
end
