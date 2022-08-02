# STEPS TO RUN SEED
#
# 1.- Generate a backup from the core DB with only the schema.
# 2.- Create a new DB and point the database.yml to it.
# 3.- Restore the previous backup in the new DB.
# 4.- Run the seed.
# require 'factory_bot_rails'
# Create sample users
# 25.times do |_t|
#   user = [
#     proc { FactoryBot.create(:full_user, :with_documentation_approved, :argentinian) },
#     proc { FactoryBot.create(:full_user, :with_documentation_rejected, :argentinian) },
#     proc { FactoryBot.create(:full_user, :with_documentation_pending, :argentinian) },
#     proc { FactoryBot.create(:full_user, :argentinian) }
#   ].sample.call
# end

# Create sample users with bank accounts
# 5.times do |_t|
#   FactoryBot.create(:full_user, :with_documentation_approved, :argentinian, :with_user_bank_account)
# end

# Assign role superadmin
# User.first.update(email: 'admin@sesocio.com', password: '12345678', role: :superadmin)
require 'database_cleaner'
require 'faker'

DatabaseCleaner.clean_with(:truncation)

sections = [
  {
    type: 'guide',
    description: Faker::Lorem.paragraph,
    image_url: '20211512155623.jpg',
    name: 'Guía'
  },
  {
    type: 'cafe_crypto',
    description: Faker::Lorem.paragraph,
    image_url: '20211512155623.jpg',
    name: 'Cafe Cripto'
  },
  {
    type: 'podcast',
    description: Faker::Lorem.paragraph,
    image_url: '20211512155623.jpg',
    name: 'Podcats'
  }
]

sections.each do |c|
  Section.create(c)
end

chapters = []

4.times do |_t|
  chapters.push(
    section_id: Faker::Number.within(range: 0..2),
    position: Faker::Number.within(range: 1..10),
    name: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph,
    image_url: '20211512155623.jpg',
    created_at: Time.now,
    updated_at: Time.now
  )
end

chapters.each do |c|
  Chapter.create(c)
end

articles_cafe_crypto = []
articles_guide = []
articles_podcast = []

15.times do |_t|
  articles_cafe_crypto.push(
    {
      section_id: 1,
      chapter_id: Faker::Number.within(range: 1..4),
      body: Faker::Lorem.paragraph,
      title: Faker::Lorem.sentence,
      reading_time: Faker::Number.within(range: 1..20),
      position: Faker::Number.within(range: 1..10),
      published: Time.now,
      published_at: Time.now,
      created_at: Time.now,
      updated_at: Time.now
    }
  )

  articles_guide.push(
    {
      section_id: 0,
      chapter_id: Faker::Number.within(range: 1..4),
      body: Faker::Lorem.paragraph,
      title: Faker::Lorem.sentence,
      reading_time: Faker::Number.within(range: 1..20),
      position: Faker::Number.within(range: 1..10),
      published: Time.now,
      published_at: Time.now,
      created_at: Time.now,
      updated_at: Time.now
    }
  )

  articles_podcast.push(
    {
      section_id: 2,
      chapter_id: Faker::Number.within(range: 1..4),
      body: Faker::Lorem.paragraph,
      title: Faker::Lorem.sentence,
      reading_time: Faker::Number.within(range: 1..20),
      position: Faker::Number.within(range: 1..10),
      published: Time.now,
      published_at: Time.now,
      created_at: Time.now,
      updated_at: Time.now
    }
  )
end

articles_cafe_crypto.each do |c|
  Article.create(c)
end

articles_guide.each do |c|
  Article.create(c)
end

articles_podcast.each do |c|
  Article.create(c)
end
