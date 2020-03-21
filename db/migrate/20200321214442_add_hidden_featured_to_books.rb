class AddHiddenFeaturedToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :hidden, :integer, default: false
    add_column :books, :featured, :integer, default: false
  end
end
