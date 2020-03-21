include ApplicationHelper

class Book < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :bookmarks
  has_many :users, through: :bookmarks

  scope :featured_not_hidden, -> { where(featured: true, hidden: false) }
  scope :not_featured_not_hidden, -> { where(featured: false, hidden: false) }

  validates :title, :author, :cover_image_url, presence: true
  
  before_save :update_chapters_count, 
              unless: proc { |book| book.chapters_count.eql?(book.sections.chapters.count) }

  SKIPS = 4
  CHARACTERS_PER_PAGE = 3500
  
  def location_in_range(location = 0)
    location = location.to_i >= 0 ? location.to_i : 0
    max_number_of_locations > location ? location : (max_number_of_locations - 1)
  end
  
  def scroll_in_range(scroll)
    scroll ||= 0 
    scroll = scroll.tr('_', '.') if scroll.respond_to? :tr
    scroll = scroll.to_d
    scroll = scroll >= 0 ? scroll : 0
    scroll <= 100 ? scroll : 100
  end
  
  def progress_with_scroll(location, scroll)
    progress_start(location) + (scroll * 0.01 * section_progress_points(location)).to_i
  end

  def progress_start(location)
    text_read_length = completed_sections(location).map { |section| section.text.length }.reduce(:+).to_i
    text_read_length * 100 / to_valid_dividend(text_length)
  end
  
  def section_progress_points(location)
    if main_text?(location)
      get_section_from_location(location).text.length * 100.0 / to_valid_dividend(text_length)
    else 
      0
    end
  end
  
  def completed_sections(location)
    completed_sections?(location) ? sections.first(location - SKIPS) : []
  end
  
  def max_number_of_locations
    sections_count + SKIPS
  end
  
  def main_text?(location)
    location >= SKIPS
  end
  
  def completed_sections?(location)
    location > SKIPS
  end
  
  def get_section_from_location(location)
    order = location - SKIPS + 1
    get_section_from_order(order)
  end
  
  def get_section_from_order(order)
    sections.with_order(order).first if sections.with_order(order).count.positive?
  end
  
  def sample_text
    return '' if sections.empty?
    sample_sections.first(2).last.clean_sample
  end
  
  def sample_editor_texts
    sample_sections.first(6).map(&:clean_sample)
  end
  
  def background_image
    "background-image: url(#{background_image_url}); background-size: auto;" if background_image_url.present?
  end

  private
  
  def sample_sections
    if sections.sample_worthy.count <= 1
      sections
    else
      sections.sample_worthy.order(:order)
    end
  end
  
  def update_chapters_count
    self.chapters_count = sections.chapters.count
  end
end
