class BookmarksController < ApplicationController
  before_action :logged_in_user, only: %i[new destroy]
  before_action :generate_bookmark, only: :new

  def new
    if @bookmark && @bookmark.save
      flash[:success] = 'Your place has been saved.'
      redirect_to open_book_path(@bookmark.book_id, @bookmark.location, scroll: @bookmark.scroll)
    else
      flash[:danger] = 'There was an error with your bookmark.'
      redirect_to current_user
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    
    if current_user == @bookmark.user 
      @bookmark.destroy
      flash[:success] = 'Your bookmark was deleted.'
    else
      flash[:danger] = 'That is not your bookmark.'
    end
    
    redirect_to user_url(current_user)
  end
  
  private

  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    return true if logged_in?
    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end
  
  def generate_bookmark
    return false unless Book.exists?(params[:book_id])
    book_id = params[:book_id]
    location = params[:location].to_i
    scroll = params[:scroll].to_i
    @bookmark = Bookmark.new(book_id: book_id, user_id: current_user.id, location: location, scroll: scroll)
  end
end
