require 'test_helper'

class SectionsControllerTest < ActionController::TestCase
  def setup
    @public_book = books(:public)
    @read_user = users(:read)
    @admin_user = users(:admin)
  end
    
  test 'should redirect new when not logged in' do
    post :new
    assert_redirected_to login_url
  end

  test 'should redirect new when logged in as read-only user' do
    log_in_as(@read_user)
    post :new
    assert_redirected_to root_url
  end

  test 'should post new when logged in as admin user' do
    log_in_as(@admin_user)
    post :new, params: { upload: { auto_assign_chapter_nums: 0, book_id: 1, ebook_file: '' } }
    assert_response :success
  end
end
