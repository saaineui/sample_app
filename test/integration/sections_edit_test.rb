require 'test_helper'

class SectionsEditTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:other)
		@section = sections(:one)
    end
    
    test "regular user can not create sections" do
        log_in_as(@user)
        post upload_review_path
        assert_redirected_to root_path
    end

end
