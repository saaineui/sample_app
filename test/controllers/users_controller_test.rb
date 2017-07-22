require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @admin_user = users(:admin)
    @read_user = users(:read)
  end
    
  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should redirect show when not logged in' do
    get :show, id: @read_user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in' do
    get :edit, id: @admin_user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch :update, id: @admin_user, user: { name: @admin_user.name, email: @admin_user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should show logged in user\'s profile' do
    log_in_as(@read_user)
    get :show, id: @read_user
    assert_response :success
  end

  test 'should show other user profiles when logged in' do
    log_in_as(@read_user)
    get :show, id: @admin_user
    assert_response :success
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@read_user)
    get :edit, id: @admin_user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@read_user)
    patch :update, id: @admin_user, user: { name: @admin_user.name, email: @admin_user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect index when not logged in' do
    get :index
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete :destroy, id: @admin_user
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@read_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @admin_user
    end
    assert_redirected_to root_url
  end


end
