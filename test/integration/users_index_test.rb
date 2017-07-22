require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
    
    def setup
        @admin_user = users(:admin)
        @read_user = users(:read)
    end
    
    test 'index as admin' do
        log_in_as(@admin_user)
        get users_path
        assert_template 'users/index'
        assert_difference 'User.count', -1 do
            delete user_path(@read_user)
        end
    end

    test 'index as read-only user' do
        log_in_as(@read_user)
        get users_path
        assert_select 'a', text: 'delete', count: 0

        assert_difference 'User.count', 0 do
            delete user_path(@admin_user)
        end
    end

end