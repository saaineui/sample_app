class BooksController < ApplicationController
  before_action :admin_user, only: %i[index new create edit update destroy upload]
  before_action :find_book_or_redirect, only: %i[show edit update destroy galley print upload]
  
  POSITIONS = { 'Front' => (0..1), 'Back' => (2..3) }.freeze
    
  def index
    @books = Book.all
    @title = { subtitle: 'Manage Books' }
  end

  def new
    @book = Book.new
    @title = { subtitle: 'New Book' }
  end

  def create
    @book = Book.new(book_params)
    
    if @book.save
      flash[:success] = "#{@book.title} has been added."
      redirect_to upload_book_path(@book)
    else
      @title = { subtitle: 'New Book' }
      render 'new'
    end
  end

  def show 
    generate_progress_vars

    # Get section content 
    @section = @book.get_section_from_location(@location) if @book.main_text?(@location) 

    # Use book metadata as title
    @title = { title: @book.title, subtitle: use_custom_page_subtitle? ? @section.index_title : @book.author }
  end

  def edit
    @title = { subtitle: "Edit #{@book.title}" }
  end

  def update
    @title = { subtitle: "Edit #{@book.title}" }
    
    if @book.update_attributes(book_params)
      flash[:success] = "#{@book.title} has been updated."
    end
    
    render 'edit'
  end

  def upload
    @title = { subtitle: "Upload #{@book.title}" }
  end

  def destroy
    title = @book.title
    sections_count = 0    
    @book.sections.each { |section| sections_count += 1 if section.destroy }
    
    if @book.destroy
      flash[:success] = "The book #{title} and #{sections_count} section(s) were deleted."
    else
      flash[:success] = "#{sections_count} section(s) were deleted."
      flash[:error] = "The book #{title} could not be deleted."      
    end    
    redirect_to books_url
  end
  
  def galley
    @title = { subtitle: "#{@book.title} - Galleys" }
    
    # Using similar JS to show, get heights of text and divide by page height to get num pages per chapter
    # Map this info to a hash - each position gets section number & scroll count OR generates blank page
    
    render layout: '/layouts/galley'
  end
  
  def print
    @position = params[:position] || 'Front'
    @page_height = params[:page_height].to_i
    @title = { subtitle: "#{@book.title} - Print #{@position}" }
      
    process_pages
    process_images
    
    render layout: '/layouts/galley' # plain styling
  end
  
  private
  
  def book_params
    params.require(:book).permit(:title, :author, :subtitle, :logo_url, :copyright, :epigraph, :cover_image_url, :background_image_url, :text_length, section_attributes: %i[id title])
  end
  
  def use_custom_page_subtitle?
    @section && @section.indexable?
  end
  
  def generate_progress_vars
    @location = @book.location_in_range(params[:location])
    @scroll = @book.scroll_in_range(params[:scroll])
    @section_progress_points = @book.section_progress_points(@location)
    @progress_start = @book.progress_start(@location)
  end
  
  def process_pages # sort page data passed by galley.js
    if params[:pages].nil?
      @pages = []
      return false
    end
    @pages = JSON.parse(params[:pages]).select { |page| position_matches?(page) } 
    @pages.sort_by! { |page| get_sort_order(page) }
  end
  
  def process_images # store image src counts to process multiple instances where exist
    if params[:images].nil?
      @images = []
      @image_src_counts = []
      return false
    end
    @images = JSON.parse(params[:images]) 
    @image_src_counts = @images.map{ |image| image['src'] }
    @image_src_counts = @image_src_counts.uniq.select{ |src| @image_src_counts.count(src) > 1 }
  end
    
  def position_matches?(page)
    POSITIONS[@position].include?(page['page_position'])
  end
    
  def get_sort_order(page)
    ((page['signature'] - 1) * 32) + ((page['signature_order'] - 1) * 4) + page['page_position']
  end

  # Before filters
  
  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless logged_in? && current_user.admin?
  end
  
  def find_book_or_redirect
    if Book.exists?(params[:id]) 
      @book = Book.find(params[:id]) 
    else
      redirect_to root_url
    end
  end
end
