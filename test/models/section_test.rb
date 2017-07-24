require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  def setup
    @section = Section.new(title: 'Ex', order: 3, chapter: 2, text: 'Lorem ipsum', indexable: true, book_id: 1)
  end
  
  test 'should be valid' do
    assert @section.valid?
  end

  test 'order should be present' do
    @section.order = nil
    assert_not @section.valid?
  end
  
  test 'book_id should be present' do
    @section.book_id = nil
    assert_not @section.valid?
  end
  
  test 'chapters scope returns array of all indexable sections' do
    assert_equal Section.chapters.count, 3
    
    Section.chapters.each do |section|
      assert section.indexable
    end
  end
  
  test 'index_prefix method returns formatted chapter number if chapter exists' do
    assert_equal @section.index_prefix, '2. '
  end
  
  test 'index_prefix method returns empty string if chapter is nil' do
    @section.chapter = nil
    
    assert_equal @section.index_prefix, ''
  end
  
  test 'index_title method returns expressive title string' do
    assert_equal @section.index_title, '2. Ex'
  end
  
  test 'index_title method returns expressive title string if chapter is nil' do
    @section.chapter = nil
    
    assert_equal @section.index_title, 'Ex'
  end
  
  test 'book_location method returns location pointing to section' do
    @section_with_book = sections(:one)
    
    assert_equal @section_with_book.book_location, 4
    assert_equal @section_with_book.book.get_section_from_location(@section_with_book.book_location), 
                 @section_with_book
  end
  
end
