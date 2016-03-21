require 'test_helper'

class BooksEditTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:other)
		@book = books(:sample_book)
    end
    
    test "regular user can not create books" do
        log_in_as(@user)
        get new_book_path
        assert_redirected_to root_path
    end

    test "regular user can not upload books" do
        log_in_as(@user)
        get upload_book_path(@book)
        assert_redirected_to root_path
    end

    test "regular user can not edit books" do
        log_in_as(@user)
        get edit_book_path(@book)
		original_title = @book.title
        title  = "Foo Bar"
        patch book_path(@book), book: { title:  title }

        @book.reload
        assert_equal original_title, @book.title
    end

    test "regular user can not delete books" do
        log_in_as(@user)
        delete book_path(@book)
        assert_redirected_to root_path
    end

end
