class CreateSectionTable < ActiveRecord::Migration[6.1]
  def change
    create_table :sections do |t|
      t.integer 'type', default: 0
      t.string 'name'
      t.text 'description'
      t.string 'image_url'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
  end
end
