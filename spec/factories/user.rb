FactoryBot.define do
  factory :user do |f|
    f.firstname                       { Faker::Name.first_name }
    f.lastname                        { Faker::Name.last_name }
    f.password                        { Faker::Internet.password(min_length: 5, max_length: 20) }
    f.password_updated_at             { Time.now - rand(10..100).days }
    f.email                           { Faker::Internet.safe_email }
    f.address                         { Faker::Address.street_address }
    f.provider                        { nil }
    f.profile_invest_shares           { true }
    f.profile_invest_lending          { true }
    f.profile_request_loan            { false }
    f.profile_post_project            { false }
    f.city                            { Faker::Address.city }
    f.state                           { Faker::Address.state }
    f.timezone                        { 'Buenos Aires' }
    f.pending_withdrawal_amount       { 0.0 }
    f.bank_account_type               { 'caja_ahorro' }
    f.total_investments               { 0 }
    f.total_investments_amount_usd    { 0 }
    f.photo_content_type              { 'image/jpeg' }
    f.photo_file_size                 { Faker::Number.number(digits: 3) }
    f.currency                        { 'USD' }
    f.terms                           { true }
    f.blocked_amount                  { 0.0 }
    f.gross_annual_income             { 0.0 }
    f.available_amount                { 0 }
    f.role                            { :basic }

    trait :full do |g|
      g.phone                   { Faker::Number.number(digits: 8).to_s }
      g.gender                  { Faker::Gender.binary_type.downcase }
      g.terms                   { true }
      g.bank_account_currency   { 'ARS' }
      g.blocked_amount          { 0.0 }
      g.gross_annual_income     { 0.0 }
      g.document                { Faker::Number.number(digits: 8).to_s }
    end

    trait :existing_user do |g|
      g.firstname                       { 'Ivana' }
      g.lastname                        { 'Moyano' }
      g.password                        { Faker::Internet.password(min_length: 5, max_length: 20) }
      g.password_updated_at             { Time.now - rand(10..100).days }
      g.email                           { 'ivana.moyano@sesocio.com' }
    end

    trait :argentinian do |g|
      g.country                 { 'AR' }
      g.bank_account_currency   { 'ARS' }
      g.cuit                    { Faker::Argentina.cuit gender, document }
      g.crypto_wallet	do
        {
          'ARS' => {
            'cvu' => Faker::Number.number(digits: 22).to_s,
            'alias' => "SS.#{firstname[0..5]}.#{lastname[0..5]}".upcase
          }
        }
      end
    end

    trait :foreign do |g|
      g.country                 { 'CL' }
      g.bank_account_currency   { 'CL' }
    end

    trait :with_user_bank_account do
      after(:create) do |user|
        create(:user_bank_account, :ars, user: user)
      end
    end

    trait :with_documentation_rejected do
      after(:create) do |user|
        create(:selfie_rejected, user_id: user.id)
        create(:front_document_rejected, user_id: user.id)
        create(:back_document_rejected, user_id: user.id)
      end
    end

    trait :with_documentation_approved do |g|
      g.is_valid { true }
      after(:create) do |user|
        create(:selfie_approved, user_id: user.id)
        create(:front_document_approved, user_id: user.id)
        create(:back_document_approved, user_id: user.id)
      end
    end

    trait :with_documentation_pending do
      after(:create) do |user|
        create(:selfie_pending, user_id: user.id)
        create(:front_document_pending, user_id: user.id)
        create(:back_document_pending, user_id: user.id)
      end
    end

    trait :with_phone_verified do
      after(:create) do |user|
        user.update_columns(
          phone: Faker::Argentina.mobile,
          phone_verification_step: :phone_verified,
          verified_code_phone_at: Time.now - 24.hours
        )
      end
    end

    factory :full_user, traits: [:full]
    factory :full_user_documentation_approved, traits: %i[full with_documentation_approved argentinian]

    factory :full_user_documentation_rejected, traits: %i[full with_documentation_rejected]

    factory :admin_user_documentation_approved, traits: %i[full with_documentation_approved with_portfolio]
    factory :admin_user_documentation_rejected, traits: %i[full with_documentation_rejected admin]

    factory :wealthy_user, traits: %i[wealthy full]
    factory :admin_user, traits: %i[full admin]

    factory :full_user_documentation_approved_foreign, traits: %i[full with_documentation_approved foreign]
  end
end
