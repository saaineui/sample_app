class SectionsController < ApplicationController
  before_action :admin_user, only: :new
  before_action :redirect_if_missing_data, only: :new
  before_action :find_book_or_redirect, only: :new
  
  def new
    @book.sections.each(&:delete) # Delete old sections, if any
    @auto_assign_chapter_nums = params[:upload][:auto_assign_chapter_nums].to_i == 1
    @chapter_num = 0

    process_file
    save_book_or_redirect
  end
  
  private
  
  def process_file
    raw_text = Nokogiri::HTML(params[:upload][:ebook_file])
    @book.text_length = raw_text.to_s.length

    raw_text.xpath('//section').each_with_index do |section, index|
      add_a_section(section, index)      
      section.unlink
    end
  end

  def add_a_section(section, index)
    new_section = Section.new(order: index + 1, title: '', text: section.to_s, book: @book)

    if new_chapter?(section)
      new_section.title = get_title(section)
      new_section.chapter = @chapter_num += 1 if @auto_assign_chapter_nums
    end

    new_section.indexable = !new_section.title.empty?
    new_section.save
  end
  
  def new_chapter?(data)
    !data.xpath('//header').empty? && data.xpath('//header').first.parent == data
  end
  
  def get_title(data)
    data.xpath('//header').first.inner_text.to_s.strip.gsub(/\s+/, ' ')
  end
  
  def save_book_or_redirect
    if @book.save
      @book.reload
      flash[:success] = 'Your file was uploaded.'        
      @title = { subtitle: "Review Upload for #{@book.title}" }
    else
      flash[:error] = 'Your upload failed. Please check your file and try again.'
      redirect_to upload_book_path(@book)
    end
  end
  
  # Before filters
  
  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless logged_in? && current_user.admin?
  end
  
  def redirect_if_missing_data
    redirect_to(upload_book_path) unless valid_form_data?
  end
  
  def valid_form_data?
    params[:upload] && params[:upload][:book_id] && params[:upload][:ebook_file]
  end

  def find_book_or_redirect
    if Book.exists?(params[:upload][:book_id])
      @book = Book.find(params[:upload][:book_id])
    else
      flash[:error] = 'That book does not exist.'
      redirect_to user_path(current_user)
    end
  end  
end
