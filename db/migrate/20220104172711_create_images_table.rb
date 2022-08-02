class CreateImagesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.references :imageable, polymorphic: true
      t.string 'name'
      t.string 'content_type'
      t.integer 'file_size'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
  end
end
