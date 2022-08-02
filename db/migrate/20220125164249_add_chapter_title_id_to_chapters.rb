class AddChapterTitleIdToChapters < ActiveRecord::Migration[6.1]
  def change
    add_column :chapters, :chapter_title_id, :text, null: false, default: ""
  end
end
