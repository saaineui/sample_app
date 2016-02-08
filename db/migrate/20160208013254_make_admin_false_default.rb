class MakeAdminFalseDefault < ActiveRecord::Migration
    def change
        change_column_default :users, :admin, from: nil, to: false
    end
end
