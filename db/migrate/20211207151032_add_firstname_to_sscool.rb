class AddFirstnameToSscool < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :firstname, :string
  end
end
