class SectionsController < ApplicationController
    before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
    
    def new
		   @book = Book.find(params[:upload][:book_id])
		   raw_text = Nokogiri::HTML(params[:upload][:ebook_file])
		   @sections = raw_text.xpath("//section")
    end
    
    def bulkmake
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
