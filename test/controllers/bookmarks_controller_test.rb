require 'test_helper'

class BookmarksControllerTest < ActionController::TestCase

    def setup
        @public_book = books(:public)
        @read_user = users(:read)
        @admin_user = users(:admin)
        @bookmark = Bookmark.create(book: @public_book, user: @read_user, location: 5, scroll: 25)
    end
    
    test "get new should add bookmark and redirect back to bookmarked page" do
        log_in_as(@read_user)

        assert_difference 'Bookmark.count', 1 do
            get :new, book_id: @public_book, user_id: @read_user, location: 5, scroll: 25
        end
        assert_redirected_to open_book_path(@public_book, 5, scroll: 25)
    end

    test "get new should redirect to login page when not logged in" do
        get :new, book_id: @public_book, user_id: @read_user, location: 5, scroll: 25
        assert_redirected_to login_url
    end
    
    test "destroy should delete bookmark and redirect back to user profile page" do
        log_in_as(@read_user)
        
        assert_difference 'Bookmark.count', -1 do
            delete :destroy, id: @bookmark
        end
        assert_redirected_to @read_user
    end

    test "destroy should redirect to login page when not logged in" do
        delete :destroy, id: @bookmark
        assert_redirected_to login_url
    end
    
    test "destroy should not delete bookmark if not bookmark owner" do
        log_in_as(@admin_user)

        assert_no_difference 'Bookmark.count' do
            delete :destroy, id: @bookmark
        end
        assert_redirected_to @admin_user
    end
    
end
