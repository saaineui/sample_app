class Section < ActiveRecord::Base
    has_and_belongs_to_many :books
    
    validates :order, presence: true
	
	scope :chapters, -> { where(indexable: true) }
	
	def index_title
		prefix = self.chapter.nil? ? "" : self.chapter.to_s + ". "		
		prefix + self.title.gsub(/(\A\s?|\s?\Z)/,"")
	end
    
    def book_location
        order + Book::SKIPS - 1
    end
end