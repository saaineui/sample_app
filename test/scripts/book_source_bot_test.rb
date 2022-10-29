require 'test_helper'
require_relative '../../lib/scripts/book_source_bot'
require_relative '../../lib/scripts/scripts_constants'
require_relative '../fixtures/peter_pan_chapters'

class BookSourceBotTest < ActiveSupport::TestCase
  TEST_CSV = 'test'
  TEST_URL = 'https://www.gutenberg.org/files/16/16-h/16-h.htm'
  TEST_TOC_SELECTOR = '.toc a'
  DEFAULT_TOC_SELECTOR = 'td a'
  DEFAULT_CHAPTER_END_SELECTOR = 'a[name]'
  
  TEST_ITEM_NIL = {
    url: '',
    title: '',
    chapters: [],
    toc_selector: DEFAULT_TOC_SELECTOR,
    chapter_title_selector: DEFAULT_TOC_SELECTOR,
    chapter_end_selector: DEFAULT_CHAPTER_END_SELECTOR
  }
  TEST_ITEM_STUB = {
    url: TEST_URL,
    title: '',
    chapters: [],
    toc_selector: TEST_TOC_SELECTOR,
    chapter_title_selector: TEST_TOC_SELECTOR,
    chapter_end_selector: DEFAULT_CHAPTER_END_SELECTOR
  }
  TEST_ITEM = {
    url: TEST_URL,
    title: 'Peter Pan',
    chapters: PETER_PAN_CHAPTERS,
    toc_selector: TEST_TOC_SELECTOR,
    chapter_title_selector: TEST_TOC_SELECTOR,
    chapter_end_selector: DEFAULT_CHAPTER_END_SELECTOR
  }
  
  def clean_html(html)
    html = html.gsub(/\s+/, ' ')
    html = html.gsub(/[ \t]+<([^i])/, '<\1')
    html = html.gsub(/<(p|h3|div|pre)( class="[\w -]+")?>[ \t]+/, '<\1\2>')
    html = html.gsub(/<\/p></, "</p>#{ScriptsConstants::LINE_BREAK}<")
    html = html.gsub(/<\/pre></, "</pre>#{ScriptsConstants::LINE_BREAK}<")
    html = html.gsub(/<\/h3></, "</h3>#{ScriptsConstants::LINE_BREAK}<")
    html = html.gsub(/<\/div></, "</div>#{ScriptsConstants::LINE_BREAK}<")
  end

  test '#new_book_source_item handles nil' do
    assert_equal TEST_ITEM_NIL, BookSourceBot.new_book_source_item() 
  end

  test '#new_book_source_item creates a new item stub from URL-only row' do
    test_item = TEST_ITEM_NIL.merge( { url: TEST_URL } )
    row = [
      TEST_URL
      ]
    
    assert_equal test_item, BookSourceBot.new_book_source_item(row)
  end

  test '#new_book_source_item creates a new item stub from row' do
    test_item_stub = TEST_ITEM_STUB.dup
    row = [
      TEST_URL,
      TEST_TOC_SELECTOR,
      TEST_TOC_SELECTOR,
      DEFAULT_CHAPTER_END_SELECTOR
      ]
    
    assert_equal test_item_stub, BookSourceBot.new_book_source_item(row)
  end

  test '#scrape_book handles nil item_url' do
    item = {
      url: '',
      toc_selector: DEFAULT_TOC_SELECTOR,
      chapter_title_selector: DEFAULT_TOC_SELECTOR,
      chapter_end_selector: DEFAULT_CHAPTER_END_SELECTOR
    }

    assert_equal item, BookSourceBot.scrape_book(item)
  end

  test '#scrape_book handles 404' do
    item = {
      url: 'https://www.gutenberg.org/notapage',
      toc_selector: DEFAULT_TOC_SELECTOR,
      chapter_title_selector: DEFAULT_TOC_SELECTOR,
      chapter_end_selector: DEFAULT_CHAPTER_END_SELECTOR
    }

    assert_equal item, BookSourceBot.scrape_book(item)
  end

  test '#scrape_book returns item matching our sample' do
    skip
    test_item_stub = TEST_ITEM_STUB.dup
    
    assert_equal TEST_ITEM, BookSourceBot.scrape_book(test_item_stub)
  end

  test '#generate_files creates a file matching our sample' do
    BookSourceBot.generate_files('test')

    book_fixture = clean_html(File.open('test/fixtures/files/peter-pan.html').read)
    book_generated = clean_html(File.open('lib/scripts/book_source_files/peter-pan.html').read)

    assert_equal book_fixture, book_generated
  end
end
