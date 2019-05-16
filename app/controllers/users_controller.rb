class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :require_admin, except: :destroy
  before_action :find_user_or_redirect, only: %i[show edit update destroy]
  before_action :require_owner, only: %i[edit update]
  
  def index
    @users = User.all
    @title = { subtitle: 'All Users' }
  end

  def new
    @user = User.new
    @title = { subtitle: 'Sign up for spineless' }
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'That was easy. Happy reading!'
      redirect_to @user
    else
      @title = { subtitle: 'Sign up for spineless' }
      render 'new'
    end
  end
  
  def show
    @title = { subtitle: "About #{@user.name}" }
  end

  def edit
    @title = { subtitle: "Edit #{@user.name}" }
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user
      flash[:success] = 'Changes to your profile have been saved.'
    else
      @title = { subtitle: "Edit #{@user.name}" }
      render 'edit'
    end
  end

  def destroy
    user_name = @user.name
    
    if @user.destroy
      flash[:success] = "User #{user_name} has been deleted."
    else
      flash[:error] = "User #{user_name} could not be deleted."
    end
    
    redirect_back fallback_location: users_url
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters
  def find_user_or_redirect
    if User.exists?(params[:id])
      @user = User.find(params[:id])
    else
      flash[:danger] = 'The requested page was not found.'
      redirect_back fallback_location: users_path
    end
  end
  
  def require_owner
    return true if current_user?(@user)
    flash[:danger] = 'You do not have permission to do that.'
    redirect_back fallback_location: current_user
  end
end
