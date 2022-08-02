FactoryBot.define do
  factory :tagging do |f|
    f.association                     :tag
    f.association                     :article
    f.created_at                      { Time.now }
    f.updated_at                      { Time.now }
  end
end
