class Bookmark < ActiveRecord::Base
	belongs_to :user
	belongs_to :book
	
	validates :user_id, :book_id, :location, :scroll, :presence => true
	
	def url
		"/books/" + book_id.to_s + "/" + location.to_s + "?scroll=" + scroll.to_s
	end
    
    def name
        "#{book.title.to_s} (#{book.progress_with_scroll(book.clean_location(location), book.clean_scroll(scroll)).to_s}%)"
    end
end