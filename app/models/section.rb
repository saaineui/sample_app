include ActionView::Helpers::SanitizeHelper

class Section < ApplicationRecord
  belongs_to :book
  
  validates :order, :book, presence: true

  scope :chapters, -> { where(indexable: true) }
  scope :with_order, ->(order) { where(order: order).limit(1) }
  scope :sample_worthy, -> { where('length(text) > 480') }

  def index_title
    index_prefix + title.strip
  end
  
  def index_prefix
    chapter ? chapter.to_s + '. ' : ''		
  end
  
  def book_location
    order + Book::SKIPS - 1
  end
  
  def clean_sample
    sample = strip_tags(text.split('.').last(4).join('.')).strip
    sample = sample.truncate(725, ' ') + '..' if sample.length > 725
    sample + '.'
  end
end
