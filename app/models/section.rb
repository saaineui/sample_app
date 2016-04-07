class Section < ActiveRecord::Base
    has_and_belongs_to_many :books
    
    validates :order, presence: true
	
	scope :chapters, -> { where(chapter: true) }
	
	def index_title
		"#{self.order.to_s}. #{self.title.gsub(/(\A\s?|\s?\Z)/,"")}"
	end
end