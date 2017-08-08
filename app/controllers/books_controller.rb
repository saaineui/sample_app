class BooksController < ApplicationController
  skip_before_action :require_login, only: %i[show galley print]
  skip_before_action :require_admin, only: %i[show galley print]
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
    @location = @book.location_in_range(params[:location])
    @scroll = @book.scroll_in_range(params[:scroll])
    @section = @book.get_section_from_location(@location) if @book.main_text?(@location) 
    @title = { title: @book.title, subtitle: use_custom_page_subtitle? ? @section.index_title : @book.author }
  end

  def edit
    @title = { subtitle: "Edit #{@book.title}" }
  end

  def update
    @title = { subtitle: "Edit #{@book.title}" }
    flash[:success] = "#{@book.title} has been updated." if @book.update_attributes(book_params)
    render 'edit'
  end

  def upload
    @title = { subtitle: "Upload #{@book.title}" }
  end

  def destroy
    if @book.destroy
      flash[:success] = "The book #{@book.title} was deleted."
    else
      flash[:error] = "The book #{@book.title} could not be deleted." 
    end
    redirect_to books_url
  end
  
  def galley
    @title = { subtitle: "#{@book.title} - Galleys" }
    render layout: '/layouts/galley'
  end
  
  def print
    @page_height = params[:page_height].to_i
    @title = { subtitle: "#{@book.title} - Print #{params[:position]}" }
    @pages = processed_pages
    @single_images, @multiple_images = processed_images
    render layout: '/layouts/galley' # plain styling
  end
  
  private
  
  def book_params
    params.require(:book).permit(
      :title, :author, :subtitle, :logo_url, :copyright, :epigraph, 
      :cover_image_url, :background_image_url, :text_length, section_attributes: %i[id title]
    )
  end
  
  def use_custom_page_subtitle?
    @section && @section.indexable?
  end
  
  def processed_pages # sort page data passed by galley.js
    return [] if params[:pages].nil?
    pages = JSON.parse(params[:pages]).select { |page| position_matches?(page, params[:position]) } 
    pages.sort_by { |page| get_sort_order(page) }
  end
  
  def processed_images 
    return [[], []] if params[:images].nil?
    sorted_images(JSON.parse(params[:images]))
  end
  
  def sorted_images(images)
    image_srcs = images.map { |img| img['src'] }
    single_images, multiple_images = images.partition { |img| image_srcs.count(img['src']) == 1 } 
    
    [single_images, 
     multiple_images.map { |img| img.merge('n' => sorted_images_of_type(images, img).index(img) + 1) }]
  end
  
  def sorted_images_of_type(images, image)
    images.select { |img| same_container_and_section?(img, image) }.sort_by { |img| img['n'].to_i }
  end
  
  def same_container_and_section?(image1, image2)
    image1['tagType'] == image2['tagType'] && image1['section_order'] == image2['section_order']
  end
    
  def position_matches?(page, position)
    POSITIONS[position].include?(page['page_position'])
  end
    
  def get_sort_order(page)
    ((page['signature'] - 1) * 32) + ((page['signature_order'] - 1) * 4) + page['page_position']
  end

  # Before filters
  def find_book_or_redirect
    redirect_back fallback_location: root_url unless Book.exists?(params[:id]) 
    @book = Book.find(params[:id])
  end
end
