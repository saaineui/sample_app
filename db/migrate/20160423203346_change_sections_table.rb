class ChangeSectionsTable < ActiveRecord::Migration
  def change
	change_column :sections, :chapter, :integer
	add_column :sections, :indexable, :boolean, default: false
  end
end
