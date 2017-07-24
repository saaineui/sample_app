require 'test_helper'

class SectionsEditTest < ActionDispatch::IntegrationTest
  def setup
    @read_user = users(:read)
    @section = sections(:one)
  end
  
  test 'read-only user can not create sections' do
    log_in_as(@read_user)
    post upload_review_path
    assert_redirected_to root_path
  end
end
