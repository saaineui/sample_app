module ApplicationHelper
  
  def clean_title
    title = @title && @title.has_key?(:title) ? @title[:title] : "Spineless"
    title += " | " + @title[:subtitle] if @title && @title[:subtitle].present?
    title
  end
  
  def to_valid_dividend(num)
    num.to_i == 0 ? 1 : num
  end
  
  def percent_to_raw(num)
    num * 0.01
  end
  
end
