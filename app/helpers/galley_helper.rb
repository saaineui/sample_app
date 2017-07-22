module GalleyHelper

  PAGE_POSITIONS = ["FL","FR","BL","BR"]
    
  def get_sidebar_string(page = nil) 
    if page
      "S#{page['signature']}-So#{page['signature_order']}-#{PAGE_POSITIONS[page['page_position']]}---#{page['page_num']}"
    else
      '[sidebar]'
    end
  end

end
