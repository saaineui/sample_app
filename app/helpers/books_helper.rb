module BooksHelper
  PAGE_POSITIONS = %w[FL FR BL BR].freeze
  
  def link_to_next(book, location) 
    return nil if location + 1 >= book.max_number_of_locations
    link_to next_icon, open_book_path(book, location + 1), id: 'next-btn', rel: 'Next'
  end
  
  def link_to_previous(book, location) 
    return nil if location <= 0
    path_options = location <= Book::SKIPS ? {} : { scroll: 100 }
    link_to previous_icon, open_book_path(book, location - 1, path_options), id: 'back-btn', rel: 'Back'
  end
  
  def next_icon
    nav_icon('M5 0 L 15 15 L 5 30', 'M25 0 L 35 15 L 25 30')
  end
  
  def previous_icon
    nav_icon('M15 0 L 5 15 L 15 30', 'M35 0 L 25 15 L 35 30')
  end
  
  def nav_icon(path1_d, path2_d)
    options = { width: 40, height: 30, viewBox: '0 0 40 30', xmlns: 'http://www.w3.org/2000/svg', class: 'arrow' }
    path1 = tag.path('', d: path1_d)
    path2 = tag.path('', d: path2_d)
    tag.svg([path1, path2].join.html_safe, options)
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
