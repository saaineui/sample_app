class CoverColumnBookmarkModel < ActiveRecord::Migration[4.2]
  def change
    add_column :books, :cover_image_url, :string
	remove_column :books, :slug

      create_table :bookmarks do |t|
          t.integer :user_id
          t.integer :book_id
		  t.integer :location
		  t.integer :percent
          
          t.timestamps null: false
      end
	  
	  add_index :bookmarks, :user_id
	  add_index :bookmarks, :book_id

  end
end
