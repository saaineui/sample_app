class SectionsController < ApplicationController
    before_action :admin_user, only: [:new]
    before_action :has_valid_form_data, only: [:new]
    
    def new
        if Book.exists?(params[:upload][:book_id])
            @book = Book.find(params[:upload][:book_id])
            raw_text = Nokogiri::HTML(params[:upload][:ebook_file])
            @book.text_length = raw_text.to_s.length
            @book.sections.each { |section| section.delete } # Delete old sections, if any

            auto_assign_chapter_nums = params[:upload][:auto_assign_chapter_nums].to_i == 1
            @chapter_num = 0
		
            raw_text.xpath("//section").each_with_index do |section, index|
                add_a_section(section, index, auto_assign_chapter_nums)            
                section.unlink
            end

            if @book.save
                @book.reload
                flash[:success] = "Your file was uploaded."
                
                @title = { subtitle: "Review Upload for #{@book.title}" }
            else
                upload_failure
            end
        else
            upload_failure
        end
    end
    
    private

        def add_a_section(section, index, auto_assign_chapter_nums)
            new_section = Section.new(order: index + 1, title: "", text: section.to_s, book: @book)

            if is_a_new_chapter?(section)
                new_section.title = get_title(section)
                new_section.chapter = @chapter_num += 1 if auto_assign_chapter_nums
            end
		
            new_section.indexable = !new_section.title.empty?
	    new_section.save
        end
    
        def is_a_new_chapter?(data)
            data.xpath("//header").length > 0 && data.xpath("//header").first.parent == data
        end
    
        def get_title(data)
            data.xpath("//header").first.inner_text.to_s.gsub(/\a/,"").gsub(/\s+/," ")
        end
    
        def upload_failure
            flash[:error] = "Your upload failed. Please check your file and try again."
            render upload_book_path(@book)
        end
  
        # Before filters
  
        # Confirms an admin user.
        def admin_user
            redirect_to(root_url) unless logged_in? && current_user.admin?
        end
    
        def has_valid_form_data
            redirect_to(upload_book_path) unless params[:upload] && params[:upload][:book_id] && params[:upload][:ebook_file]
        end
	
end
