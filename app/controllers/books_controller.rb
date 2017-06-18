class BooksController < ApplicationController
    before_action :admin_user, only: [:index, :new, :create, :edit, :update, :destroy, :upload]

    def index
        @books = Book.all
        @title = { subtitle: "Manage Books" }
    end

    def new
        @book = Book.new
        @title = { subtitle: "New Book" }
    end

    def create
        @book = Book.new(book_params)
        
        if @book.save
            flash[:success] = "#{@book.title} has been added."
            redirect_to upload_book_path(@book)
        else
            @title = { subtitle: "New Book" }
            render 'new'
        end
    end

    def show
        @book = Book.find(params[:id])

        # Get progress variables
        @location = @book.location_in_range(params[:location])
        @scroll = @book.scroll_in_range(params[:scroll])
        @scroll_as_decimal = percent_to_raw(@scroll)
        @section_slice_length = @book.section_slice_length(@location)
        @progress_start = @book.progress_start(@location)
        @progress_with_scroll = @book.progress_with_scroll(@location, @scroll)
        
        # Get section content 
        @section = @book.get_section_from_location(@location) if @book.main_text?(@location) 

        # Use book metadata as title
        @title = { title: @book.title, subtitle: use_custom_page_subtitle? ? @section.index_title : @book.author }
    end

    def edit
        @book = Book.find(params[:id])
        @title = { subtitle: "Edit #{@book.title}" }
    end

    def update
        @book = Book.find(params[:id])
        @title = { subtitle: "Edit #{@book.title}" }
        
        if @book.update_attributes(book_params)
            flash[:success] = "#{@book.title} has been updated."
        end
        
        render 'edit'
    end

    def upload
        @book = Book.find(params[:id])
        @title = { subtitle: "Upload #{@book.title}" }
    end

    def destroy
        @book = Book.find(params[:id])
        title = @book.title
        sections_count = 0
        
        @book.sections.each do |section|
            sections_count += 1 if section.destroy
        end
        
        if @book.destroy
            flash[:success] = "The book #{title} and #{sections_count} section(s) were deleted."
        else
            flash[:success] = "#{sections_count} section(s) were deleted."
            flash[:error] = "The book #{title} could not be deleted."            
        end
        
        redirect_to books_url
    end
    
    def galley
        @book = Book.find(params[:id])
        @title = { subtitle: "#{@book.title} galley view" }
        
        # Using similar JS to show, get heights of text and divide by page height to get num pages per chapter
        # Map this info to a hash - each position gets section number & scroll count OR generates blank page
        
        render layout: "/layouts/galley"
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
