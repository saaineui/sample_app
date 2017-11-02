module BooksHelper
  PAGE_POSITIONS = %w[FL FR BL BR].freeze
  
  def link_to_next(book, location) 
    return nil if location + 1 >= book.max_number_of_locations
    link_to next_icon, open_book_path(book, location + 1), id: 'next-btn', rel: 'Next'
  end
  
  def link_to_previous(book, location) 
    return nil if location <= 0
    link_to previous_icon, open_book_path(book, location - 1), id: 'back-btn', rel: 'Back'
  end
  
  def next_icon
    options = { width: 20, height: 20, viewBox: '0 0 20 20', xmlns: 'http://www.w3.org/2000/svg', class: 'arrow' }
    triangle = tag.polygon('', points: '0,0 15,10 0,20')
    line = tag.line('', x1: 18, x2: 18, y1: 0, y2: 20)
    tag.svg([triangle, line].join.html_safe, options)
  end
  
  def previous_icon
    options = { width: 20, height: 20, viewBox: '0 0 20 20', xmlns: 'http://www.w3.org/2000/svg', class: 'arrow' }
    triangle = tag.polygon('', points: '20,0 5,10 20,20')
    line = tag.line('', x1: 3, x2: 3, y1: 0, y2: 20)
    tag.svg([triangle, line].join.html_safe, options)
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
    section = @book.get_section_from_order(page['order'])
    return nil unless section
    div_style = 'margin-top:' + (-1 * @page_height * page['pages_before']).to_s + 'px'
    content_tag(:div, section.text.html_safe, class: 'rendered-text', style: div_style)
  end
end
