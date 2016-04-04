class RemoveAffinitiesTables < ActiveRecord::Migration
  def change
      drop_table :affinities
	  drop_table :affinities_users
  end
end
