require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase
    
  def setup
    @user = User.first
    @book = Book.last
    @bookmark = Bookmark.create(user: @user, book: @book, location: 5, scroll: 50)
  end
  
  test 'should be valid' do
    assert @bookmark.valid?
  end

  test 'user should be present' do
    @bookmark.user = nil
    assert_not @bookmark.valid?
  end

  test 'book should be present' do
    @bookmark.book = nil
    assert_not @bookmark.valid?
  end

  test 'location should be present' do
    @bookmark.location = nil
    assert_not @bookmark.valid?
  end

  test 'scroll should be present' do
    @bookmark.scroll = nil
    assert_not @bookmark.valid?
  end
  
  test 'percent_read method returns integer' do
    assert_equal @bookmark.percent_read.class, Integer
  end
  
  test 'name method prints book title and progress' do
    assert_equal @bookmark.name, 'Lorem Ipsum: A Love Story (49%)'
  end

  test 'percent_read method returns integer if book is deleted' do
    @book.delete
    @bookmark.reload

    assert_equal @bookmark.percent_read.class, Integer
  end
  
  test 'name method prints string if book is deleted' do
    @book.delete
    @bookmark.reload
    
    assert_equal @bookmark.name, 'Book #2 can not be found.'
  end
end
