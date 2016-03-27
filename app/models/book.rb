class Book < ActiveRecord::Base
    has_and_belongs_to_many :sections
    
    validates :title, :author, :logo_url, presence: true
end