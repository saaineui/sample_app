class Book < ActiveRecord::Base
    has_and_belongs_to_many :sections
    
    validates :title, :slug, :author, presence: true
end