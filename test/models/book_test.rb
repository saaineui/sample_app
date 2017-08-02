require 'test_helper'

class BookTest < ActiveSupport::TestCase
  def setup
    @book = Book.new(title: 'Ex ex', author: 'Ex Ex', logo_url: 'http://ex.png', cover_image_url: 'http://ex.png')
    @book_with_sections = books(:public)
  end
  
  test 'should be valid' do
    assert @book.valid?
  end

  test 'title should be present' do
    @book.title = '   '
    assert_not @book.valid?
  end

  test 'author should be present' do
    @book.author = '   '
    assert_not @book.valid?
  end

  test 'logo_url should be present' do
    @book.logo_url = '   '
    assert_not @book.valid?
  end

  test 'cover_image_url should be present' do
    @book.cover_image_url = '   '
    assert_not @book.valid?
  end
  
  test 'display scope should filter my books' do
    Book.display.each { |book| assert_not_equal book.author, 'Stephanie Sun' }
  end
  
  test 'SKIPS constant returns integer' do
    assert_equal Book::SKIPS.to_i, Book::SKIPS
  end
  
  test 'get_section_from_order method returns section' do
    output = @book_with_sections.get_section_from_order(2)
    
    assert_equal output.class.name, 'Section'
    assert_equal output.title, 'MyString 2'
  end
  
  test 'get_section_from_location method returns section' do
    output = @book_with_sections.get_section_from_location(5)
    
    assert_equal output.class.name, 'Section'
    assert_equal output.title, 'MyString 2'
  end
  
  test 'completed_sections? method returns true only at 2nd section in main text' do
    assert_not @book_with_sections.completed_sections?(2)
    assert_not @book_with_sections.completed_sections?(4)
    assert @book_with_sections.completed_sections?(5)
  end
  
  test 'main_text? method returns true only in main text' do
    assert_not @book_with_sections.main_text?(2)
    assert @book_with_sections.main_text?(4)
    assert @book_with_sections.main_text?(5)
  end
  
  test 'max_number_of_locations method returns number of valid locations' do
    assert_equal @book.max_number_of_locations, 4
    assert_equal @book_with_sections.max_number_of_locations, 7
  end
  
  test 'completed_sections method returns empty array for front matter and first main text location' do
    assert_equal @book_with_sections.completed_sections(2), []
    assert_equal @book_with_sections.completed_sections(4), []
  end
  
  test 'completed_sections method returns array of completed main text sections' do
    output = @book_with_sections.completed_sections(6)
    
    assert_equal output.class, Array
    assert_equal output.count, 2
    assert_equal output.first.class.name, 'Section'
    assert_equal output.first.title, 'MyString'
  end
  
  test 'location_in_range method returns integer' do
    assert_equal @book.location_in_range(3), 3
    assert_equal @book.location_in_range('3'), 3
    assert_equal @book.location_in_range('three'), 0
    assert_equal @book.location_in_range, 0
  end
  
  test 'location_in_range method maxes out' do
    assert_equal @book.location_in_range(300), 3
  end
  
  test 'scroll_in_range method returns integer within range' do
    assert_equal @book.scroll_in_range(-3), 0
    assert_equal @book.scroll_in_range(3), 3
    assert_equal @book.scroll_in_range(33.33), 33
    assert_equal @book.scroll_in_range(101), 100
  end
  
  test 'progress_start method returns length of fully completed sections as percent of total' do
    assert_equal @book_with_sections.progress_start(6), 1800 / 28
    assert_equal @book_with_sections.progress_start(5), 800 / 28
  end
  
  test 'progress_start method returns 0 for front matter and first main text location' do
    assert_equal @book_with_sections.progress_start(2), 0
    assert_equal @book_with_sections.progress_start(4), 0
  end
  
  test 'section_progress_points method returns section length as percent of total' do
    assert_equal @book_with_sections.section_progress_points(4), (800 / 28)
    assert_equal @book_with_sections.section_progress_points(5), (1000 / 28)
  end

  test 'section_progress_points method returns 0 for front matter' do
    assert_equal @book_with_sections.section_progress_points(2), 0
  end
  
  test 'progress_with_scroll method returns expected value' do
    assert_equal @book_with_sections.progress_with_scroll(4, 10), (10 * 8 / 28)
    assert_equal @book_with_sections.progress_with_scroll(5, 50), (800 / 28 + (50 * 10 / 28).to_i)
    assert_equal @book_with_sections.progress_with_scroll(6, 33), (1800 / 28 + (33 * 10 / 28).to_i)
  end
  
  test 'progress_with_scroll method returns 0 for front matter' do
    assert_equal @book_with_sections.progress_with_scroll(2, 10), 0
  end
end
