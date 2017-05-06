class Bookmark < ActiveRecord::Base
	belongs_to :user
	belongs_to :book
	
	validates :user_id, :book_id, :location, :scroll, :presence => true
	
	def url
		"/books/" + book_id.to_s + "/" + location.to_s + "?scroll=" + scroll.to_s
	end
    
    def name
        "#{book.title.to_s} (#{percent_read.to_s}%)"
    end
    
    def percent_read
        book.progress_with_scroll(book.location_in_range(location), percent_to_raw(book.scroll_in_range(scroll)))
    end
end