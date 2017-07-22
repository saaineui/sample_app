require 'test_helper'

class BooksReadTest < ActionDispatch::IntegrationTest

  def setup
    @read_user = users(:read)
		@books = [books(:public), books(:hidden)]
  end
  
  test 'read without logging in' do
    book = @books.first
    
    get book_path(book)
    assert_select 'a#next-btn[href=?]', open_book_path(book, 1)
    
    (1..book.max_number_of_locations-1).each do |location|
      get open_book_path(book, location)
      assert_select 'a#bookmark[href=?]', open_book_url(book, location)

      if location == book.max_number_of_locations-1
        assert_select 'a#next-btn', count: 0
      else
        assert_select 'a#next-btn[href=?]', open_book_path(book, location+1)
      end

      get open_book_path(book, location, scroll: Random.rand(1..100))
      assert_template 'books/show'
    end
  end
  
  test 'log in and read' do
    book = @books.last
    
    post login_path, session: { email: @read_user.email, password: 'password' }
    assert is_logged_in?

    get book_path(book)
    assert_template 'books/show'

    (1..book.max_number_of_locations-1).each do |location|
      scroll = Random.rand(1..100)
      save_bookmark_href = new_bookmark_path(book_id: book, location: location, scroll: scroll)
      
      get open_book_path(book, location, scroll: scroll)
      assert_select 'a#new-bookmark[href=?]', save_bookmark_href
      
      assert_difference 'Bookmark.count', 1 do
        get save_bookmark_href
      end
      assert_redirected_to open_book_path(book, location, scroll: scroll)
      
      follow_redirect!
      assert_template 'books/show'
      assert_not flash.empty?
    end
    
    get user_path(@read_user)
    assert_select 'tr th a', count: book.max_number_of_locations-1
    assert_select 'tr td a', count: book.max_number_of_locations-1
  end
  
end
