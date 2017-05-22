require 'test_helper'

class BooksEditTest < ActionDispatch::IntegrationTest

    def setup
        @read_user = users(:read)
        @admin_user = users(:admin)
		@book = books(:public)
    end
    
    test "regular user can not edit books" do
        log_in_as(@read_user)
        get edit_book_path(@book)
        assert_redirected_to root_path
        
        original_title = @book.title
        patch book_path(@book), book: { title: "Foo Bar" }
        assert_redirected_to root_path

        @book.reload
        assert_equal original_title, @book.title
    end

    test "regular user can not delete books" do
        log_in_as(@read_user)
        
        assert_no_difference "Book.count" do
            delete book_path(@book)
        end
        assert_redirected_to root_path
    end

    test "edit book metadata, upload new text" do
        log_in_as(@admin_user)       
        
        patch book_path(@book), book: { title: "Foo Bar", author: "Ruby Rails", subtitle: "", logo_url: "http://stephsun.com/books/usc/constitution_logo.png", cover_image_url: "http://stephsun.com/books/usc/us_constitution.jpg", background_image_url: "http://stephsun.com/books/usc/flag.png", epigraph: "<p class=\"epi-quote\">Short Epigraph</p>", copyright: "<p class=\"tightcenter\">Short Copyright</p>" }
        @book.reload
        assert_equal @book.title, "Foo Bar"

        follow_redirect!
        assert_select "title", "Foo Bar | Ruby Rails"

        assert_difference "Section.all.count", 27 do
            post upload_review_path, upload: { assign_chapters: 1, book_id: @book.id, ebook_file: fixture_file_upload('files/constitution.html','text/html') }
        end
        assert_template "sections/new"
        assert !flash.empty?
        
        [[1, "Ruby Rails"], [5, "2. Section. 1."], [10, "7. Section. 6."], [30, "27. Article. VI."]].each do |location, subtitle|
            get book_path(@book, location: location)
            assert_select "title", "Foo Bar | "+subtitle
        end
    end

    test "user book deletion" do
        log_in_as(@admin_user)
        
        assert_difference "Book.count", -1 do
            delete book_path(@book)
        end
        assert_redirected_to books_path
    end

end
