class ChangeIntroductionToArticles < ActiveRecord::Migration[6.1]
  def change
    change_column :articles, :introduction, :text, null: false, default: ""
  end
end
