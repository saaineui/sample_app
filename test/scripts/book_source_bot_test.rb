require 'test_helper'
require_relative '../../lib/scripts/book_source_bot'
require_relative '../fixtures/peter_pan_chapters'

class BookSourceBotTest < ActiveSupport::TestCase
  TEST_CSV = 'test'
  TEST_URL = 'https://www.gutenberg.org/files/16/16-h/16-h.htm'
  NIL_STUB = {
    url: '',
    title: '',
    chapters: [],
  }
  TEST_BOOK_SOURCE_ITEM_STUB = {
    url: TEST_URL,
    title: '',
    chapters: []
  }
  TEST_BOOK_SOURCE_ITEM = {
    url: TEST_URL,
    title: 'Peter Pan',
    chapters: PETER_PAN_CHAPTERS
  }

  test '#new_book_source_item handles nil' do
    assert_equal NIL_STUB, BookSourceBot.new_book_source_item() 
  end

  test '#new_book_source_item creates a new item stub from url' do
    assert_equal TEST_BOOK_SOURCE_ITEM_STUB, BookSourceBot.new_book_source_item(TEST_URL)
  end

  test '#scrape_book handles nil item_url' do
    item = {
      url: nil
    }

    assert_equal item, BookSourceBot.scrape_book(item)
  end

  test '#scrape_book handles 404' do
    item = {
      url: 'https://www.gutenberg.org/notapage',
    }

    assert_equal item, BookSourceBot.scrape_book(item)
  end

  test '#scrape_book returns item matching our sample' do
    assert_equal TEST_BOOK_SOURCE_ITEM, BookSourceBot.scrape_book(TEST_BOOK_SOURCE_ITEM_STUB)
  end

#  test '#generate_import_file creates a file matching our sample' do
#    BookSourceBot.generate_import_files(TEST_CODES_SCRAPER, TEST_URL_SCRAPER)
#
#    books_sample = File.open('spec/fixtures/books_smartling.xml').read.gsub(/( |\t)/, '')
#    books_zd = File.open('import_files/sl_books_zd_1.xml').read.gsub(/( |\t)/, '')
#
#    expect(books_sample).to eq(books_zd)
#
#    File.delete('import_files/sl_books_zd_1.xml')
#  end
end