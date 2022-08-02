# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_26_151357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.bigint "section_id"
    t.bigint "chapter_id"
    t.text "body"
    t.string "title"
    t.boolean "published"
    t.integer "reading_time"
    t.integer "position"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.boolean "new", default: false
    t.integer "difficulty_level", default: 0
    t.text "introduction", default: "f"
    t.text "short_description", default: "", null: false
    t.text "article_title_id", default: "", null: false
    t.text "link"
  end

  create_table "chapters", force: :cascade do |t|
    t.integer "section_id"
    t.integer "position"
    t.string "name"
    t.text "description"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "chapter_title_id", default: "", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.integer "parent_id"
    t.integer "article_id"
    t.index ["article_id"], name: "index_comments_on_article_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.string "name"
    t.string "content_type"
    t.integer "file_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable"
  end

  create_table "sections", force: :cascade do |t|
    t.integer "type", default: 0
    t.string "name"
    t.text "description"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "section_title_id", default: "", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_articles", force: :cascade do |t|
    t.integer "article_id"
    t.integer "user_id"
    t.decimal "reading_percentage"
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
