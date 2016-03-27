class AddTextLengthToBooks < ActiveRecord::Migration
  def change
	add_column :books, :text_length, :integer
  end
end
