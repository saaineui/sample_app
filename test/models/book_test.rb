require 'test_helper'

class BookTest < ActiveSupport::TestCase
    
    def setup
        @book = Book.new(title: "Clean Code", author: "Uncle Bob", logo_url: "http://cleancode.com/logo.png", cover_image_url: "http://cleancode.com/cover.png")
        
        @book_with_sections = books(:public)
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
    
    test "display scope should filter my books" do
        assert_equal Book.display.count, 1
        
        Book.display.each do |book|
            assert_not_equal book.author, "Stephanie Sun"
        end
    end
    
    test "SKIPS constant returns integer" do
        assert_equal Book::SKIPS.to_i, Book::SKIPS
    end
    
    test "location_in_range method returns integer" do
        assert_equal @book.location_in_range(3), 3
        assert_equal @book.location_in_range("3"), 3
        assert_equal @book.location_in_range("three"), 0
        assert_equal @book.location_in_range, 0
    end
    
    test "location_in_range method maxes out" do
        assert_equal @book.location_in_range(300), 3
    end
    
    test "scroll_in_range method returns integer within range" do
        assert_equal @book.scroll_in_range(-3), 0
        assert_equal @book.scroll_in_range(3), 3
        assert_equal @book.scroll_in_range(33.33), 33
        assert_equal @book.scroll_in_range(101), 100
    end
    
    test "section_slice_length method returns section length as percent of total" do
        assert_equal @book_with_sections.section_slice_length(4), (800/18)
    end

    test "section_slice_length method returns 0 for front matter" do
        assert_equal @book_with_sections.section_slice_length(2), 0
    end
    
end
