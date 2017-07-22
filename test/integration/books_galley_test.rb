require 'test_helper'

class BooksGalleyTest < ActionDispatch::IntegrationTest
    
    def setup
        @book = books(:public) 
    end
    
    test "galley sections render" do
        get galley_book_path(@book)
        assert_select ".page", count: 5
        assert_select ".sidebar", count: 5
        
        @book.sections.each do |section|
            assert_select ".rendered-text", section.text
        end
    end
            
    test "print front sections render" do
        post print_book_path(@book), { position: "front", pages: create_pages_json }
        assert_select ".page", count: 8
        assert_select ".sidebar", count: 8
        assert_select ".sidebar", 'S1-So1-FR---1'
        
        @book.sections.each do |section|
            assert_select ".rendered-text", section.text
        end
    end
            
end
