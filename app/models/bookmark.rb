class Bookmark < ActiveRecord::Base
    belongs_to :user
    belongs_to :book
	
    validates :user_id, :book_id, :location, :scroll, :presence => true
	
    def name
        book ? "#{book.title} (#{percent_read.to_s}%)" : "Book ##{book_id} can not be found."
    end
    
    def percent_read
        book ? book.progress_with_scroll(book.location_in_range(location), book.scroll_in_range(scroll)) : 0
    end
end