class AddShortDescriptionArticles < ActiveRecord::Migration[6.1]
    def change
      add_column :articles, :short_description, :text, null: false, default: ""
    end
end
