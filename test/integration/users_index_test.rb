require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
    
    def setup
        @admin     = users(:user)
        @non_admin = users(:other)
    end
    
test "index as admin" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_difference 'User.count', -1 do
        delete user_path(@non_admin)
    end
end

test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
end

end