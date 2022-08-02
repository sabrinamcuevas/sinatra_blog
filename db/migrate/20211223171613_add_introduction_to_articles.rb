class AddIntroductionToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :introduction, :text, default: false
  end
end
