class BooksController < ApplicationController
    before_action :admin_user, only: [:index, :new, :create, :edit, :update, :destroy, :upload, :update_length]

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
		@page_subtitle = @book.author

		@skips = 4 # Cover, title page, epigraph, copyright
		@location = (@book.sections.count+@skips) > params[:location].to_i ? params[:location].to_i : (@book.sections.count+@skips-1)
		@scroll = params[:scroll].to_i <= 100 ? params[:scroll].to_i * 0.01 : 1
		
		@override_background = @book.background_image_url.present?
		@background_image_url = @book.background_image_url
		
		@progress_start = 0
		@section_slice_length = 0
		
		if @location > @skips
			@book.sections.first(@location-@skips).each do |section| 
				@progress_start += section.text.length 
			end
		end
		@progress_start = @progress_start * 100 / to_valid_dividend(@book.text_length)

		if @location >= @skips
			@section_slice_length = @book.sections[@location-@skips].text.length * 100 / to_valid_dividend(@book.text_length)
			
			# Override subtitle with section title if section is indexable
			@page_subtitle = @book.sections[@location-@skips].index_title if @book.sections[@location-@skips].indexable?
		end
		
		# Prescroll if bookmark link
		@progress_with_scroll = (@progress_start + @scroll * @section_slice_length).to_i
		
		# Convert to integer
		@progress_start = @progress_start.to_i
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
      params.require(:book).permit(:title, :author, :logo_url, :copyright, :epigraph, :cover_image_url, :background_image_url, :text_length, section_attributes: [:id,:title])
  end
  
  def to_valid_dividend(num)
	num.to_i == 0 ? 1 : num
  end
  
  # Before filters
  
  # Confirms an admin user.
  def admin_user
      redirect_to(root_url) unless logged_in? && current_user.admin?
  end
end
