class RemoveAffinitiesTables < ActiveRecord::Migration[4.2]
  def change
      drop_table :affinities
	  drop_table :affinities_users
  end
end
