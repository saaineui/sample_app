require 'test_helper'

class DeletedBooksTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:admin)
    @book = books(:public)
  end

  test 'handle deleted bookmarked books flexibly' do
    post login_path, params: { session: { email: @admin_user.email, password: 'password' } }
    get new_bookmark_path(book_id: @book, location: 1, scroll: 50)
    delete book_path(@book)
    get user_path(@admin_user)
    assert_select 'ul.bookmarks li a', "Book ##{@book.id} can not be found."
  end
end
