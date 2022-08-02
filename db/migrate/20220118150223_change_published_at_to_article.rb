class ChangePublishedAtToArticle < ActiveRecord::Migration[6.1]
  def change
    change_column :articles, :published_at, :datetime, null: true, default: nil
  end
end
