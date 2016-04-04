class Bookmark < ActiveRecord::Base
	belongs_to :user
	belongs_to :book
	
	validates :user_id, :book_id, :location, :scroll, :presence => true
	
	def url
		"/books/" + self.book_id.to_s + "?location=" + self.location.to_s + "&scroll=" + self.scroll.to_s
	end
end