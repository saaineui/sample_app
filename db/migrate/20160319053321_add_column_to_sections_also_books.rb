class AddColumnToSectionsAlsoBooks < ActiveRecord::Migration
  def change
    add_column :sections, :chapter, :boolean
    add_column :books, :background_image_url, :string
  end
end
