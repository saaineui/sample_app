class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index show edit update destroy]
  before_action :correct_user,   only: %i[edit update]
  before_action :admin_user,   only: :destroy
  
  def index
    @users = User.all
    @title = { subtitle: 'All Readers' }
  end

  def new
    @user = User.new
    @title = { subtitle: 'Sign Up' }
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'That was easy. Happy reading!'
      redirect_to @user
    else
      @title = { subtitle: 'Sign Up' }
      render 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
    @title = { subtitle: "About #{@user.name}" }
  end

  def edit
    @user = User.find(params[:id])
    @title = { subtitle: "Edit #{@user.name}" }
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user
      flash[:success] = 'Changes to your profile have been saved.'
    else
      @title = { subtitle: "Edit #{@user.name}" }
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    user_name = @user.name
    
    if @user.destroy
      flash[:success] = "User #{user_name} has been deleted."
    else
      flash[:error] = "User #{user_name} could not be deleted."
    end
    
    redirect_to users_url
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    return true if logged_in?
    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
