require 'test_helper'

class BooksReadTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:other)
		@books = [books(:public), books(:hidden)]
    end
    
    test "read without logging in" do
        get book_path(@books.first)
		assert_template 'books/show'
        
        (2..@books.first.max_number_of_locations).each do |location|
            get book_path(@books.first, location)
            get book_path(@books.first, location, scroll: Random.rand(1..100))
            assert_template 'books/show'
        end
    end
    
    test "log in and read" do
        get login_path
        post login_path, session: { email: @user.email, password: 'password' }
        get book_path(@books.last)

        assert_template 'books/show'

        (2..@books.last.max_number_of_locations).each do |location|
            get book_path(@books.last, location)
            get book_path(@books.last, location, scroll: Random.rand(1..100))
            assert_template 'books/show'
        end
    end
    
end
