module ApplicationHelper
  
  # return clean title
  def clean_title(page_title = '')
    base_title = "Spineless"
    if page_title.empty?
      base_title
    else
      base_title + " | " + page_title
    end
  end
end
