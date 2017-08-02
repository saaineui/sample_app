class BookmarksController < ApplicationController
  skip_before_action :require_admin
  before_action :generate_bookmark, only: :new
  before_action :find_bookmark_or_redirect, only: :destroy
  before_action :require_owner, only: :destroy

  def new
    if @bookmark && @bookmark.save
      flash[:success] = 'Your place has been saved.'
      redirect_to open_book_path(@bookmark.book_id, @bookmark.location, scroll: @bookmark.scroll)
    else
      flash[:danger] = 'There was an error with your bookmark.'
      redirect_back fallback_location: current_user
    end
  end

  def destroy
    if @bookmark.destroy
      flash[:success] = 'Your bookmark was deleted.'
    else
      flash[:danger] = 'Bookmark delete failed. Please try again later.'
    end
    
    redirect_back fallback_location: current_user
  end
  
  private
  
  # before filters
  def generate_bookmark
    return false unless Book.exists?(params[:book_id])
    @bookmark = Bookmark.new(
      book_id: params[:book_id], 
      user_id: current_user.id, 
      location: params[:location].to_i, 
      scroll: params[:scroll].to_i
    )
  end

  def find_bookmark_or_redirect
    redirect_back fallback_location: current_user unless Bookmark.exists?(params[:id]) 
    @bookmark = Bookmark.find(params[:id])
  end
  
  def require_owner
    return true if current_user?(@bookmark.user)
    flash[:danger] = 'That is not your bookmark.'
    redirect_back fallback_location: current_user
  end
end
