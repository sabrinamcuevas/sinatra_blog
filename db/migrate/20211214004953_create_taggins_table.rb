class CreateTagginsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :taggings do |t|
      t.integer 'tag_id'
      t.integer 'article_id'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
  end
end
