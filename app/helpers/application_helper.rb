module ApplicationHelper
  
    def clean_title(override, page_title = '')
        base_title = override && params[:id] && Book.exists?(params[:id]) ? Book.find(params[:id]).title : "Spineless"
        base_title += " | " + page_title unless page_title.empty?
    end
    
    def to_valid_dividend(num)
        num.to_i == 0 ? 1 : num
    end
    
    def percent_to_raw(num)
        num * 0.01
    end
  
end
