require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase
        
    def setup
        @user = User.first
        @book = Book.last
        @bookmark = Bookmark.new(user: @user, book: @book, location: 10, scroll: 50)
    end
    
    test "should be valid" do
        assert @bookmark.valid?
    end

    test "user should be present" do
        @bookmark.user = nil
        assert_not @bookmark.valid?
    end

    test "book should be present" do
        @bookmark.book = nil
        assert_not @bookmark.valid?
    end

    test "location should be present" do
        @bookmark.location = nil
        assert_not @bookmark.valid?
    end

    test "scroll should be present" do
        @bookmark.scroll = nil
        assert_not @bookmark.valid?
    end

end
