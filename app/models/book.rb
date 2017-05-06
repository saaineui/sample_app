include ApplicationHelper

class Book < ActiveRecord::Base
    has_and_belongs_to_many :sections
	has_many :bookmarks
	has_many :users, through: :bookmarks
	
	scope :display, -> { where("author!=?","Stephanie Sun") }
    
    validates :title, :author, :logo_url, :cover_image_url, presence: true
    
    SKIPS = 4
    
    def location_in_range(location = 0)
        location = location.to_i >= 0 ? location.to_i : 0
		max_number_of_locations > location ? location : (max_number_of_locations-1)
    end
    
    def scroll_in_range(scroll = 0)
        scroll = scroll.to_i >= 0 ? scroll.to_i : 0
        scroll <= 100 ? scroll : 100
    end
    
    def progress_with_scroll(location, scroll)
		progress_start(location) + (scroll * section_slice_length(location)).to_i
    end

    def progress_start(location)
		text_read_length = completed_sections(location).map { |section| section.text.length }.reduce(:+).to_i
        text_read_length * 100 / to_valid_dividend(text_length)
    end
    
    def section_slice_length(location)
        is_main_text?(location) ? get_section_from_location(location).text.length * 100 / to_valid_dividend(text_length) : 0
    end
    
    def completed_sections(location)
        has_completed_sections?(location) ? sections.first(location-SKIPS) : []
    end
    
    def max_number_of_locations
        sections.count + SKIPS
    end
    
    def is_main_text?(location)
        location >= SKIPS
    end
    
    def has_completed_sections?(location)
        location > SKIPS
    end
    
    def get_section_from_location(location)
        section_index = location - SKIPS
        sections[section_index]
    end
    
end