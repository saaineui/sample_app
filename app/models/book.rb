class Book < ActiveRecord::Base
    has_and_belongs_to_many :sections
	has_many :bookmarks
	has_many :users, through: :bookmarks
    
    validates :title, :author, :logo_url, :cover_image_url, presence: true
end