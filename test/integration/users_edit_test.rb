require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:admin)
  end
  
  test 'unsuccessful edit' do
    log_in_as(@admin_user)
    get edit_user_path(@admin_user)
    assert_template 'users/edit'
    patch user_path(@admin_user), 
          user: { 
            name:                  '',
            email:                 'foo@invalid',
            password:              'foo',
            password_confirmation: 'bar' 
          }
    assert_template 'users/edit'
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@admin_user)
    log_in_as(@admin_user)
    assert_redirected_to edit_user_path(@admin_user)
    name  = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@admin_user), 
          user: { 
            name:                  name,
            email:                 email,
            password:              '',
            password_confirmation: ''
          }
    assert_not flash.empty?
    assert_redirected_to @admin_user
    @admin_user.reload
    assert_equal name,  @admin_user.name
    assert_equal email, @admin_user.email
  end

  test 'admin paramater not editable' do
    log_in_as(@admin_user)
    get edit_user_path(@admin_user)
    name  = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@admin_user), 
          user: { 
            name:                  name,
            email:                 email,
            password:              '',
            password_confirmation: '',
            admin:                 false
          }
    assert_not flash.empty?
    assert_redirected_to @admin_user
    @admin_user.reload
    assert_equal @admin_user.admin, true
  end
end
