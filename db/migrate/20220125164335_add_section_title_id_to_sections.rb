class AddSectionTitleIdToSections < ActiveRecord::Migration[6.1]
  def change
    add_column :sections, :section_title_id, :text, null: false, default: ""
  end
end
