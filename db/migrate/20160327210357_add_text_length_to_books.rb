class AddTextLengthToBooks < ActiveRecord::Migration[4.2]
  def change
	add_column :books, :text_length, :integer
  end
end
