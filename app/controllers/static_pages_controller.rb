class StaticPagesController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_admin
  
  def home
    render layout: 'full'
  end
  
  def help
    render layout: 'full'
  end
end
