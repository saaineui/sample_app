class RenameSpeciesTableAffinities < ActiveRecord::Migration
  def change
      rename_table :species, :affinities
      rename_table :species_users, :affinities_users
      change_table :affinities_users do |t|
          t.rename :species_id, :affinity_id
      end
  end
end
