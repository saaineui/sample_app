class CreateSpecies < ActiveRecord::Migration[4.2]
  def change
    create_table :species do |t|
      t.string :name

      t.timestamps null: false
    end
    create_join_table :users, :species
  end
end
