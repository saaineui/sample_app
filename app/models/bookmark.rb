class Bookmark < ActiveRecord::Base
	belongs_to :user
	belongs_to :book
	
	validates :user_id, :book_id, :location, :scroll, :presence => true
	
	def url
		"/books/" + self.book_id.to_s + "/" + self.location.to_s + "?scroll=" + self.scroll.to_s
	end
    
    def name
        book.title.to_s + " (#{book.get_progress_vars(location, scroll)[:progress_with_scroll].to_i}%)"
    end
end