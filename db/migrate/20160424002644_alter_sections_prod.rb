class AlterSectionsProd < ActiveRecord::Migration
  def change
	remove_column :sections, :chapter
	add_column :sections, :chapter, :integer
	add_column :sections, :indexable, :boolean, default: false
  end
end
