require 'test_helper'

class SectionsControllerTest < ActionController::TestCase
  def setup
    @public_book = books(:public)
    @read_user = users(:read)
    @admin_user = users(:admin)
  end
    
  test 'should redirect index when not logged in' do
    post :index, params: { book_id: @public_book.id }
    assert_redirected_to login_url
  end

  test 'should redirect index when logged in as read-only user' do
    log_in_as(@read_user)
    post :index, params: { book_id: @public_book.id }
    assert_redirected_to root_url
  end

  test 'should redirect create with invalid book_id' do
    log_in_as(@admin_user)
    post :create, params: { book_id: -1, upload: { auto_assign_chapter_nums: 0, ebook_file: '' } }
    assert_redirected_to books_url
  end

  test 'should post create when logged in as admin user' do
    log_in_as(@admin_user)
    post :create, params: { book_id: @public_book.id, upload: { auto_assign_chapter_nums: 0, ebook_file: '' } }
    assert_redirected_to book_sections_path(book_id: @public_book.id)
  end
end
