class CreateChaptersTable < ActiveRecord::Migration[6.1]
  def change
    create_table :chapters do |t|
      t.integer 'section_id'
      t.integer 'position'
      t.string 'name'
      t.text 'description'
      t.string 'image_url'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
  end
end
