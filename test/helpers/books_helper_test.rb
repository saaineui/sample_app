require 'test_helper'

class BooksHelperTest < ActionView::TestCase
  setup do
    @book = books(:public)
  end
  
  test '#link_to_next should return an anchor tag to next section' do
    assert_dom_equal %(<a id="next-btn" href="/books/1/3">Next</a>), link_to_next(@book, 2)
  end
  
  test '#link_to_next should return nothing if at back of book' do
    assert_dom_equal '', link_to_next(@book, 6)
  end
  
  test '#link_to_previous should return an anchor tag to previous section' do
    assert_dom_equal %(<a id="back-btn" href="/books/1/1">Back</a>), link_to_previous(@book, 2)
  end
  
  test '#link_to_previous should return nothing if at front of book' do
    assert_dom_equal '', link_to_previous(@book, 0)
  end
  
  test '#sidebar_text should return [sidebar] if page is nil' do
    assert_dom_equal %([sidebar]), sidebar_text(nil)
  end

  test '#sidebar_text should return page metadata string that matches page hash' do
    page = { 
      'order' => 'blank', 'page_num' => 4, 'pages_before' => 0, 
      'signature' => 1, 'signature_order' => 2, 'page_position' => 2 
    }
    
    assert_dom_equal %(S1-So2-BL---4), sidebar_text(page)
  end
end
