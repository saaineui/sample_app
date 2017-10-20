class AddSampleToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :sample, :text
  end
end
