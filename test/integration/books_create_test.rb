require 'test_helper'

class BooksCreateTest < ActionDispatch::IntegrationTest
  def setup
    @read_user = users(:read)
    @admin_user = users(:admin)
    @book = books(:public)
    @book_form_data = { title: 'The Constitution of the United States', author: 'Various', subtitle: '', logo_url: 'http://stephsun.com/books/usc/constitution_logo.png', cover_image_url: 'http://stephsun.com/books/usc/us_constitution.jpg', background_image_url: 'http://stephsun.com/books/usc/flag.png', epigraph: '<p class="epi-quote">Note: The following text is a transcription of the Constitution as it was inscribed by Jacob Shallus on parchment (the document on display in the Rotunda at the National Archives Museum.) Items have since been amended or superseded. The authenticated text of the Constitution can be found on the website of the Government Printing Office.</p>', copyright: '<p class="tightcenter"><img src="http://www.stephsun.com/books/usc/flag.png" alt="U.S. flag" /></p>\n<p class="tightcenter">Public Domain</p>\n<p class="tightcenter"><a href="http://www.archives.gov/exhibits/charters/constitution_transcript.html">www.archives.gov</a></p>' }
  end
  
  test 'regular user can not create books' do
    log_in_as(@read_user)
    get new_book_path
    assert_redirected_to root_path

    assert_no_difference 'Book.count' do
      post books_path, params: { book: @book_form_data }
    end
    assert_redirected_to root_path
  end

  test 'regular user can not upload books' do
    log_in_as(@read_user)
    get upload_book_path(@book)
    assert_redirected_to root_path
    
    post upload_review_path, params: { 
      upload: { 
        auto_assign_chapter_nums: 0, 
        book_id: @book.id, 
        ebook_file: fixture_file_upload('files/constitution.html', 'text/html') 
      } 
    }
    assert_redirected_to root_path
  end

  test 'create new book record, add metadata, upload text' do
    log_in_as(@admin_user)     

    assert_difference 'Book.count', 1 do
      post books_path, params: { book: @book_form_data }
    end
    
    new_book = Book.last
    
    assert_redirected_to upload_book_path(new_book)
    
    follow_redirect!
    assert_select 'title', 'Spineless | Upload The Constitution of the United States'
    assert_select 'h3', 'The Constitution of the United States'

    post upload_review_path, params: { 
      upload: { 
        auto_assign_chapter_nums: 0, 
        book_id: new_book.id, 
        ebook_file: fixture_file_upload('files/constitution.html', 'text/html') 
      } 
    }
    assert_not flash.empty?
    assert_template 'sections/new'

    assert_equal new_book.sections.count, 30
    
    [[1, 'Various'], [5, 'Section. 1.'], [10, 'Section. 6.'], [30, 'Article. VI.']].each do |location, subtitle|
      get book_path(new_book, location: location)
      assert_select 'title', 'The Constitution of the United States | ' + subtitle
    end
    
    assert_not new_book.sample_text.empty?
  end
end
