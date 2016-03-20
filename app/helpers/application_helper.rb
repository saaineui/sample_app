module ApplicationHelper
  
  # return clean title
  def clean_title(override, page_title = '')
    # get base title
	if override
		base_title = params[:id] && Book.find(params[:id]) ? Book.find(params[:id]).title : "Book Not Found"
	else
		base_title = "Spineless"
	end
	
	# add page title if exists
    if page_title.empty?
      base_title
    else
      base_title + " | " + page_title
    end
  end
    
end
