include ApplicationHelper

class Book < ActiveRecord::Base
    has_and_belongs_to_many :sections
	has_many :bookmarks
	has_many :users, through: :bookmarks
	
	scope :display, -> { where("author!=?","Stephanie Sun") }
    
    validates :title, :author, :logo_url, :cover_image_url, presence: true
    
    def skips
        4
    end
    
    def get_progress_vars(location, scroll)
		location = (sections.count+skips) > location ? location : (sections.count+skips-1)
		scroll = scroll <= 100 ? scroll * 0.01 : 1
        
		section_slice_length = location >= skips ? sections[location-skips].text.length * 100 / to_valid_dividend(text_length) : 0
				
		text_read_length = location > skips ? sections.first(location-skips).map { |section| section.text.length }.reduce(:+) : 0
		progress_start = text_read_length * 100 / to_valid_dividend(text_length)

        return { location: location, scroll: scroll, section_slice_length: section_slice_length, progress_start: progress_start, progress_with_scroll: (progress_start + scroll * section_slice_length) }
    end
end