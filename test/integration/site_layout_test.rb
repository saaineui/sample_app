require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'header links rendered on home' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', signup_path
  end
    
  test 'public books rendered on home' do
    get root_path
    assert_select 'div.catalog img[alt=?]', books(:public).title
  end
      
  test 'private books not rendered on home' do
    get root_path
    assert_select 'div.catalog img[alt=?]', books(:hidden).title, false
  end
      
  test 'should get home when logged in as read-only user' do
    log_in_as(users(:read))
    get root_path
    assert_response :success
  end

  test 'should get home when logged in as admin' do
    log_in_as(users(:admin))
    get root_path
    assert_response :success
  end
end
