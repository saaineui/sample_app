class DropBooksSections < ActiveRecord::Migration[4.2]
  def change
      drop_table :books_sections
  end
end
