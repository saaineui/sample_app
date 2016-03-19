class SectionsController < ApplicationController
    
    def new
           flash.now[:danger] = 'Hello world'
		   @book = Book.find(params[:book_id])
    end
    
    def destroy
    end
	
end
