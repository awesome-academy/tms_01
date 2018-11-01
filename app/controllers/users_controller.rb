class UsersController < ApplicationController
  before_action :logged_in_user, :supervisor_user
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.latest.paginate page: params[:page],
      per_page: Settings.user_per_page
  end

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "controllers.users.signup_success"
      redirect_to users_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controllers.users.update_user"
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:warning] = t "controllers.users.user_deleted"
    else
      flash[:danger] = t "controllers.users.user_not_found"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :address,
      :password_confirmation, :phone_number, :role
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controllers.users.user_not_found"
    redirect_to users_path
  end

  def logged_in_user
    return if logged_in?
    flash[:danger] = t "controllers.users.pls_log_in"
    redirect_to login_path
  end

  def supervisor_user
    redirect_to(login_path) unless current_user.supervisor?
  end
end
