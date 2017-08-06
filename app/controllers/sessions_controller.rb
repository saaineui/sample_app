class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :require_admin
  
  def new
    @title = { subtitle: 'Login' }
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if authenticated?(user)
      log_in user
      flash[:success] = 'You are now logged in.'
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out
    flash[:success] = 'You are now logged out.'
    redirect_to root_url
  end
  
  private
  
  def authenticated?(user)
    user && user.authenticate(params[:session][:password])
  end
end
