require 'test_helper'

class SectionsControllerTest < ActionController::TestCase

    def setup
        @public_book = books(:public)
        @read_user = users(:read)
    end
    
  test "should redirect new when not logged in" do
    get :new
    assert_redirected_to root_url
  end

    
end
