class RedoAdminColumn < ActiveRecord::Migration[4.2]
  def change
      change_table :users do |t|
          t.remove :admin
          t.boolean :admin, default: false
      end
  end
end
