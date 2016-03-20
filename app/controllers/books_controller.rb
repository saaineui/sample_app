class BooksController < ApplicationController
    before_action :admin_user, only: [:index, :new, :create, :edit, :update, :destroy]

    def index
        @books = Book.all
    end

    def new
        @book = Book.new
    end

    def create
        @book = Book.new(book_params)
        if @book.save
            flash[:success] = "#{@book.title} has been added."
            redirect_to @book
        else
            render 'new'
        end
    end

    def show
		@override_title_logo = true
		@book = Book.find(params[:id])
		
		@override_background = @book.background_image_url.present?
		@background_image_url = @book.background_image_url
    end

    def edit
		@book = Book.find(params[:id])
    end

	def update
		@book = Book.find(params[:id])
		if @book.update_attributes(book_params)
			redirect_to @book
			flash[:success] = "#{@book.title} has been updated."
		else
			render 'edit'
		end
	end

	def upload
		@book = Book.find(params[:id])
	end

    def destroy
    end

  private
  def book_params
      params.require(:book).permit(:title, :slug, :author, :logo_url, :copyright, :epigraph, :background_image_url, section_ids: [])
  end
  
  # Before filters
  
  # Confirms an admin user.
  def admin_user
      redirect_to(root_url) unless logged_in? && current_user.admin?
  end
end
