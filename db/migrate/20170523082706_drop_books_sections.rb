class DropBooksSections < ActiveRecord::Migration
  def change
      drop_table :books_sections
  end
end
