class AddColumnsToBooks < ActiveRecord::Migration[4.2]
  def change
    add_column :books, :author, :string
    add_column :books, :logo_url, :string
    add_column :books, :epigraph, :text
    add_column :books, :copyright, :text
  end
end
