class AddCountersToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :sections_count, :integer, default: 0
    add_column :books, :chapters_count, :integer, default: 0
  end
end
