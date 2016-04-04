class BookmarksController < ApplicationController
  before_action :logged_in_user, only: [:new, :destroy]

  def new
      @bookmark = Bookmark.new(book_id: params[:book_id], user_id: current_user.id, location: params[:location].to_i, scroll: params[:scroll].to_i)
      if @bookmark.save
          flash[:success] = "Your place has been saved."
          redirect_to @bookmark.url
      else
		  flash[:danger] = "There was an error with your bookmark."
          redirect_to current_user
      end
  end

  def destroy
	  if current_user.id == Bookmark.find(params[:id]).user_id 
		Bookmark.find(params[:id]).destroy
		flash[:success] = "Your bookmark was deleted."
	  else
		flash[:danger] = "That is not your bookmark."
	  end
      redirect_to user_url(current_user)
  end
  
  private

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
        unless logged_in?
            store_location
            flash[:danger] = "Please log in."
            redirect_to login_url
        end
    end

end