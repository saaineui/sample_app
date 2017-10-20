require 'test_helper'

class SectionsEditTest < ActionDispatch::IntegrationTest
  def setup
    @read_user = users(:read)
    @section = sections(:one)
    @book = books(:public)
  end
  
  test 'read-only user can not create or review sections' do
    log_in_as(@read_user)
    post book_sections_path(book_id: @book)
    assert_redirected_to root_path
    
    get book_sections_path(book_id: @book)
    assert_redirected_to root_path
  end
end
