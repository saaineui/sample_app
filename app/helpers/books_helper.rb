module BooksHelper
  PAGE_POSITIONS = %w[FL FR BL BR].freeze
    
  def link_to_next(book, location) 
    return nil if location + 1 >= book.max_number_of_locations
    link_to 'Next', open_book_path(book, location + 1), id: 'next-btn'
  end
  
  def link_to_previous(book, location) 
    return nil if location <= 0
    link_to 'Back', open_book_path(book, location - 1), id: 'back-btn'  
  end
  
  def sidebar_text(page) 
    if page
      [
        'S' + page['signature'].to_s,
        'So' + page['signature_order'].to_s,
        PAGE_POSITIONS[page['page_position']],
        '--' + page['page_num'].to_s
      ].join('-')
    else
      '[sidebar]'
    end
  end

  def rendered_text_div_tag(page) 
    return nil if @book.sections.with_order(page['order']).count == 0
    section_text = @book.sections.with_order(page['order']).first.text.html_safe
    div_style = 'margin-top:' + (-1 * @page_height * page['pages_before']).to_s + 'px'
    content_tag(:div, section_text, class: 'rendered-text', style: div_style)
  end
end
