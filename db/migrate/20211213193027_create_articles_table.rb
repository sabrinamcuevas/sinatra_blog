class CreateArticlesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.bigint 'section_id'
      t.bigint 'chapter_id'
      t.text 'body'
      t.string 'title'
      t.boolean 'published'
      t.integer 'reading_time'
      t.integer 'position'
      t.datetime 'published_at', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
  end
end
