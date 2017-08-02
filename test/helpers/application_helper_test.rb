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
  
  test '#to_valid_dividend should return number if not zero' do
    assert_equal 64, to_valid_dividend(64)
  end

  test '#to_valid_dividend should return 1 if zero' do
    assert_equal 1, to_valid_dividend(0)
  end
end
