module ApplicationHelper
  
  # return clean title
  def clean_title(page_title = '')
    base_title = "Author of The Orientations and Connected"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
