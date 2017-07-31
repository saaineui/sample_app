require 'test_helper'

class BooksGalleyTest < ActionDispatch::IntegrationTest
  def setup
    @book = books(:public) 
  end
  
  test 'galley sections render' do
    get galley_book_path(@book)
    assert_select '.page', count: 5
    assert_select '.sidebar', count: 5
    
    @book.sections.each { |section| assert_select '.rendered-text', section.text }
  end
      
  test 'print front sections render' do
    post print_book_path(@book), params: { position: 'Front', pages: create_pages_json }
    assert_select 'h1', 'The Model Views Controllers', count: 1
    assert_select '.epigraph-wrap p', 'For DHH', count: 1
    assert_select '.page', count: 16
    assert_select '.sidebar', count: 16
    
    assert_select '.rendered-text', @book.sections.with_order(1).first.text, count: 12
  end
      
  test 'print front sections render in print order' do
    post print_book_path(@book), params: { position: 'Front', pages: create_pages_json }
    front_sidebars = %w[
      S1-So1-FL---32 S1-So1-FR---1 S1-So2-FL---30 S1-So2-FR---3 
      S1-So3-FL---28 S1-So3-FR---5 S1-So4-FL---26 S1-So4-FR---7 
      S1-So5-FL---24 S1-So5-FR---9 S1-So6-FL---22 S1-So6-FR---11 
      S1-So7-FL---20 S1-So7-FR---13 S1-So8-FL---18 S1-So8-FR---15 
    ]
    
    assert_select '.sidebar' do |sidebars| 
      sidebars.each_with_index { |sidebar, index| assert_equal front_sidebars[index], sidebar.text.gsub(/\s/, '') }
    end
  end
      
  test 'print back sections render' do
    post print_book_path(@book), params: { position: 'Back', pages: create_pages_json }
    assert_select '.page', count: 16
    assert_select '.sidebar', count: 16
    
    assert_select '.rendered-text', @book.sections.with_order(1).first.text, count: 12
  end
      
  test 'print back sections render in print order' do
    post print_book_path(@book), params: { position: 'Back', pages: create_pages_json }
    back_sidebars = %w[
      S1-So1-BL---2 S1-So1-BR---31 S1-So2-BL---4 S1-So2-BR---29
      S1-So3-BL---6 S1-So3-BR---27 S1-So4-BL---8 S1-So4-BR---25 
      S1-So5-BL---10 S1-So5-BR---23 S1-So6-BL---12 S1-So6-BR---21
      S1-So7-BL---14 S1-So7-BR---19 S1-So8-BL---16 S1-So8-BR---17 
    ]
    
    assert_select '.sidebar' do |sidebars| 
      sidebars.each_with_index { |sidebar, index| assert_equal back_sidebars[index], sidebar.text.gsub(/\s/, '') }
    end
  end
  
  test 'print images css renders' do
    post print_book_path(@book), params: { position: 'Front', images: create_images_json }
    assert_select 'style', '
  #ebook img[src=\'https://example.com/ch1.png\'] { 
    height: 54px; margin-top: 0px; margin-bottom: 9px; 
  }

  #ebook .order_2 figure:nth-of-type(1) img { 
    height: 107px; margin-top: 0px; margin-bottom: 19px; 
  }
  #ebook .order_8 figure:nth-of-type(1) img { 
    height: 107px; margin-top: 0px; margin-bottom: 19px; 
  }
  #ebook .order_8 figure:nth-of-type(2) img { 
    height: 107px; margin-top: 0px; margin-bottom: 19px; 
  }
'
  end
end
