class CreateCommentsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.bigint 'user_id'
      t.text 'comment', limit: 8
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
  end
end
