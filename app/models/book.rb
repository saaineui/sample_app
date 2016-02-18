class Book < ActiveRecord::Base
    has_and_belongs_to_many :sections
    
    validates :title, :slug, presence: true
end