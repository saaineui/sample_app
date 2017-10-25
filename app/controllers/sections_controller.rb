class SectionsController < ApplicationController
  before_action :find_book_or_redirect
  before_action :redirect_if_missing_data, only: :create
  
  def index
    @title = { subtitle: "Review Upload for #{@book.title}" }
  end
  
  def create
    @book.sections.destroy_all # Delete old sections, if any
    process_file(params[:upload][:auto_assign_chapter_nums].to_i.eql?(1))
    save_book_or_redirect
  end
  
  private
  
  def process_file(auto_assign)
    raw_text = Nokogiri::HTML(params[:upload][:ebook_file])
    @book.text_length = raw_text.to_s.length
    chapters = { auto_assign: auto_assign, num_assigned: 0 }

    raw_text.xpath('//section').each_with_index do |section, index|
      chapters = add_a_section(section, index + 1, chapters) # convert 0 index to 1 index     
      section.unlink
    end
  end

  def add_a_section(section, order, chapters)
    new_section = Section.new(order: order, title: '', text: section.to_s, book: @book)

    if new_chapter?(section)
      new_section.title = get_title(section)
      new_section.chapter = chapters[:num_assigned] += 1 if chapters[:auto_assign]
    end

    new_section.indexable = !new_section.title.empty?
    new_section.save
    chapters
  end
  
  def new_chapter?(data)
    !data.xpath('//header').empty? && data.xpath('//header').first.parent == data
  end
  
  def get_title(data)
    data.xpath('//header').first.inner_text.to_s.strip.gsub(/\s+/, ' ')
  end
  
  def save_book_or_redirect
    if @book.save
      set_default_sample
      @book.reload
      flash[:success] = 'Your file was uploaded.'
      redirect_to book_sections_path(book_id: @book)
    else
      flash[:error] = 'Your upload failed. Please check your file and try again.'
      redirect_to upload_book_path(@book)
    end
  end
  
  def set_default_sample
    @book.reload
    @book.update(sample: @book.sample_text)
  end

  # Before filters
  def find_book_or_redirect
    if Book.exists?(params[:book_id])
      @book = Book.find(params[:book_id])
    else
      flash[:error] = 'That book does not exist.'
      redirect_back fallback_location: books_url
    end
  end  

  def redirect_if_missing_data
    redirect_to(upload_book_path(@book)) unless valid_form_data?
  end
  
  def valid_form_data?
    params[:upload] && params[:upload][:ebook_file]
  end
end
