module GalleyHelper
    
  def get_sidebar_string(page) 
    "S#{page[:signature]}-So#{page.signature_order}-#{page_positions[page.page_position]}---#{page.page_num}"
  end

end
