class SectionsController < ApplicationController
    before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
    
    def new
		@book = Book.find(params[:upload][:book_id])
		raw_text = Nokogiri::HTML(params[:upload][:ebook_file])
		
		@book.sections = []
		
		raw_text.xpath("//section").each do |section|
			this_section = Section.new
			this_section.order = @book.sections.count + 1
			this_section.title = section.xpath("//header").length > 0 ? section.xpath("//header").first.inner_text.to_s.gsub(/\a/,"").gsub(/\s+/," ") : ""
			this_section.text = section.inner_text
			this_section.chapter = true
			this_section.save
			@book.sections << this_section
			section.unlink
		end
		@book.save
    end
    
    def destroy
    end

  private
  def section_params
      params.require(:section).permit()
  end
  
  # Before filters
  
  # Confirms an admin user.
  def admin_user
      redirect_to(root_url) unless logged_in? && current_user.admin?
  end
	
end
