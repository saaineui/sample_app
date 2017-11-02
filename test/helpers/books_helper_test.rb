require 'test_helper'

class BooksHelperTest < ActionView::TestCase
  setup do
    @book = books(:public)
  end
  
  test '#link_to_next should return an anchor tag to next section' do
    assert_dom_equal %(<a id="next-btn" rel="Next" href="/books/1/3"><svg width="40" height="30" viewBox="0 0 40 30" xmlns="http://www.w3.org/2000/svg" class="arrow"><path d="M5 0 L 15 15 L 5 30"></path><path d="M25 0 L 35 15 L 25 30"></path></svg></a>), link_to_next(@book, 2)
  end
  
  test '#link_to_next should return nothing if at back of book' do
    assert_dom_equal '', link_to_next(@book, 6)
  end
  
  test '#link_to_previous should return an anchor tag to previous section' do
    assert_dom_equal %(<a id="back-btn" rel="Back" href="/books/1/1"><svg width="40" height="30" viewBox="0 0 40 30" xmlns="http://www.w3.org/2000/svg" class="arrow"><path d="M15 0 L 5 15 L 15 30"></path><path d="M35 0 L 25 15 L 35 30"></path></svg></a>), link_to_previous(@book, 2)
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
  
  test '#rendered_text_div_tag(page) should return focused section text' do
    @page_height = 100
    page = { 
      'order' => 3, 'page_num' => 4, 'pages_before' => 1, 
      'signature' => 1, 'signature_order' => 2, 'page_position' => 2 
    }
    assert_dom_equal(
      %(<div class="rendered-text" style="margin-top:-100px">MyString 6</div>), 
      rendered_text_div_tag(page)
    )
  end
end
