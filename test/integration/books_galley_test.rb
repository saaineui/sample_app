require 'test_helper'

class BooksGalleyTest < ActionDispatch::IntegrationTest
    
    def setup
        @book = books(:public) 
        @pages = [
            {order: "title", page_num: 1, pages_before: 0, signature: 1, signature_order: 1}, 
            {order: "epigraph", page_num: 2, pages_before: 1, signature: 1, signature_order: 2}, 
            {order: 0, page_num: 3, pages_before: 2, signature: 1, signature_order: 3}, 
            {order: 1, page_num: 4, pages_before: 3, signature: 1, signature_order: 4}, 
            {order: 2, page_num: 5, pages_before: 4, signature: 1, signature_order: 5}, 
            {order: 3, page_num: 6, pages_before: 5, signature: 1, signature_order: 6}, 
            {order: 4, page_num: 7, pages_before: 6, signature: 1, signature_order: 7}, 
            {order: 5, page_num: 8, pages_before: 7, signature: 1, signature_order: 8}
            ].to_json
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
        post print_book_path(@book), { position: "front", pages: @pages }
        assert_select ".page", count: 8
        assert_select ".sidebar", count: 8
        
        @book.sections.each do |section|
            assert_select ".rendered-text", section.text
        end
    end
            
end
