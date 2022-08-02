class AddArticleTitleIdTableArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :article_title_id, :text, null: false, default: ""
  end
end
