class CreateJoinTableUsersBookmarks < ActiveRecord::Migration[4.2]
  def change
      create_join_table :users, :bookmarks do |t|
          t.index :user_id
          t.index :bookmark_id
      end
	  
	  remove_column :bookmarks, :user_id
  end
end
