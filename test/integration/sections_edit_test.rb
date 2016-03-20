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

=begin
    test "regular user can not edit sections" do
        log_in_as(@user)
        get edit_section_path(@section)
		original_title = @section.title
        title  = "Foo Bar"
        patch section_path(@section), section: { title:  title }

        @section.reload
        assert_equal original_title, @section.title
    end

    test "regular user can not delete sections" do
        log_in_as(@user)
        delete section_path(@section)
        assert_redirected_to root_path
    end
=end

end
