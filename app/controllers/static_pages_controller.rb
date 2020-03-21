class StaticPagesController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_admin
  
  def home
    @public_books = Book.featured_not_hidden + Book.not_featured_not_hidden
    render layout: 'full'
  end
  
  def help
    render layout: 'full'
  end
end
