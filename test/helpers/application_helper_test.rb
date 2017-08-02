require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test '#clean_title should return custom title' do
    @title = { title: 'My Book', subtitle: 'My Author' }
    assert_dom_equal %(My Book | My Author), clean_title
  end

  test '#clean_title should return title-only if no subtitle' do
    @title = { title: 'My Book', subtitle: '' }
    assert_dom_equal %(My Book), clean_title

    @title = { title: 'My Book' }
    assert_dom_equal %(My Book), clean_title
  end

  test '#render_body_classes returns string with controller and action name' do
    assert_dom_equal %(test ), render_body_classes
  end
  
  test '#render_css returns css declarations for props and data passed' do
    data = { 'color' => '#05f', 'padding_top' => '1em', 'non-css-prop' => 25 }
    assert_dom_equal %(padding-top: 1em; color: #05f), render_css(['padding_top', 'color'], data)
  end
  
  test '#to_valid_dividend should return number if not zero' do
    assert_equal 64, to_valid_dividend(64)
  end

  test '#to_valid_dividend should return 1 if zero' do
    assert_equal 1, to_valid_dividend(0)
  end
end
