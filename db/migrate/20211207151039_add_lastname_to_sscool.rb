class AddLastnameToSscool < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :lastname, :string
  end
end
