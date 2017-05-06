class BooksController < ApplicationController
    before_action :admin_user, only: [:index, :new, :create, :edit, :update, :destroy, :upload]

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
		@book = Book.find(params[:id])

        # Adjust graphics
        @override_title_logo = true
		@override_background = @book.background_image_url.present?
		@background_image_url = @book.background_image_url

        # Get progress variables
        @location = @book.location_in_range(params[:location])
        @scroll = @book.scroll_in_range(params[:scroll])
        @scroll_as_decimal = percent_to_raw(@scroll)
        @section_slice_length = @book.section_slice_length(@location)
        @progress_start = @book.progress_start(@location)
		@progress_with_scroll = @book.progress_with_scroll(@location, @scroll)
        
        # Get section content 
        @section = @book.get_section_from_location(@location) if @book.is_main_text?(@location) 
        
        # Get page subtitle
		@page_subtitle = use_custom_page_subtitle? ? @section.index_title : @book.author
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
	  @book = Book.find(params[:id])
	  title = @book.title
	  sections_count = @book.sections.count
	  @book.sections.each do |section|
		section.destroy
	  end
      @book.destroy
      flash[:success] = "The book #{title} and #{sections_count} section(s) were deleted."
      redirect_to books_url
    end

  private
    def book_params
      params.require(:book).permit(:title, :author, :subtitle, :logo_url, :copyright, :epigraph, :cover_image_url, :background_image_url, :text_length, section_attributes: [:id,:title])
    end
    
    def use_custom_page_subtitle?
        @section && @section.indexable?
    end
    
    # Before filters
  
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless logged_in? && current_user.admin?
    end
end
