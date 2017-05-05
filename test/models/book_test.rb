require 'test_helper'

class BookTest < ActiveSupport::TestCase
    
    def setup
        @book = Book.new(title: "Clean Code", author: "Uncle Bob", logo_url: "http://cleancode.com/logo.png", cover_image_url: "http://cleancode.com/cover.png")
    end
    
    test "should be valid" do
        assert @book.valid?
    end

    test "title should be present" do
        @book.title = "     "
        assert_not @book.valid?
    end

    test "author should be present" do
        @book.author = "     "
        assert_not @book.valid?
    end

    test "logo_url should be present" do
        @book.logo_url = "     "
        assert_not @book.valid?
    end

    test "cover_image_url should be present" do
        @book.cover_image_url = "     "
        assert_not @book.valid?
    end

end
