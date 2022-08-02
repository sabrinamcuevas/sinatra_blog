class AddArticleIdAndParentInComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :parent_id, :integer
    add_column :comments, :article_id, :integer
    add_index :comments, :parent_id
    add_index :comments, :article_id
  end
end
