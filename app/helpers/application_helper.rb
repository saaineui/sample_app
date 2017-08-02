module ApplicationHelper
  def clean_title
    title = @title && @title.key?(:title) ? @title[:title] : 'Spineless'
    title += ' | ' + @title[:subtitle] if @title && @title[:subtitle].present?
    title
  end
  
  def to_valid_dividend(num)
    num.to_i.zero? ? 1 : num
  end
end
