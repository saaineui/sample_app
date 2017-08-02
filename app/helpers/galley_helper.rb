module GalleyHelper
  PAGE_POSITIONS = %w[FL FR BL BR].freeze
    
  def sidebar_text(page) 
    if page
      [
        'S' + page['signature'].to_s,
        'So' + page['signature_order'].to_s,
        PAGE_POSITIONS[page['page_position']] + '-',
        '-' + page['page_num'].to_s
      ].join('-')
    else
      '[sidebar]'
    end
  end
end
