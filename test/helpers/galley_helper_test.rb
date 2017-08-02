require 'test_helper'

class GalleyHelperTest < ActionView::TestCase
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
