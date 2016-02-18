class CreateBooksTable < ActiveRecord::Migration
  def change
      create_table :books do |t|
          t.string :title
          t.string :slug
          
          t.timestamps null: false
      end
      create_table :sections do |t|
          t.string :title
          t.integer :order
          t.text :text
          
          t.timestamps null: false
      end
      create_join_table :books, :sections do |t|
          t.index :book_id
          t.index :section_id
      end
  end
end
