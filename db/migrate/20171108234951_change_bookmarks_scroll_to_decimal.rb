class ChangeBookmarksScrollToDecimal < ActiveRecord::Migration[5.1]
  def change
    change_column :bookmarks, :scroll, :decimal, default: 0.0
  end
end
