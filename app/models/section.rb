class Section < ActiveRecord::Base
    has_and_belongs_to_many :books
    
    validates :order, presence: true
	
    scope :chapters, -> { where(indexable: true) }
	
    def index_title
        index_prefix + title.gsub(/(\A\s?|\s?\Z)/,"")
    end
    
    def index_prefix
        chapter ? chapter.to_s + ". " : ""		
    end
    
    def book_location
        order + Book::SKIPS - 1
    end
end