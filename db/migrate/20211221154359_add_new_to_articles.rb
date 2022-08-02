class AddNewToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :new, :boolean, default: false
  end
end
