class AddLevelToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :difficulty_level, :integer, default: false
  end
end
