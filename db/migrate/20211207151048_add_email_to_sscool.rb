class AddEmailToSscool < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :email, :string
  end
end
