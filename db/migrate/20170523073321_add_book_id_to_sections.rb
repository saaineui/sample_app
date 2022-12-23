class AddBookIdToSections < ActiveRecord::Migration[4.2]
  def change
      change_table :sections do |t|
          t.integer :book_id
          t.index :book_id
          t.index :order
          t.index :chapter
      end
  end
end
