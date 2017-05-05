require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
    
  test "header links rendered on home" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
  end
    
  test "public books rendered on home" do
    get root_path
    assert_select "p.covers a img[alt=?]", books(:public).title
  end
      
  test "private books not rendered on home" do
    get root_path
    assert_select "p.covers a img[alt=?]", books(:hidden).title, false
  end
      
end
