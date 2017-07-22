# class Object
class Section < ActiveRecord::Base
    belongs_to :book
    
    validates :order, :book, presence: true

    scope :chapters, -> { where(indexable: true) }
    scope :with_order, ->(order) { where(order: order).limit(1) }

    def index_title
        index_prefix + title.gsub(/(\A\s?|\s?\Z)/, '')
    end
    
    def index_prefix
        chapter ? chapter.to_s + '. ' : ''		
    end
    
    def book_location
        order + Book::SKIPS - 1
    end
end
