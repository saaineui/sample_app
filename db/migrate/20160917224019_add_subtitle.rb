class AddSubtitle < ActiveRecord::Migration[4.2]
  def change
	add_column :books, :subtitle, :string
  end
end
