class CreateUserArticlesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :user_articles do |t|
      t.integer 'article_id'
      t.integer 'user_id'
      t.decimal 'reading_percentage'
      t.boolean 'read'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
  end
end
