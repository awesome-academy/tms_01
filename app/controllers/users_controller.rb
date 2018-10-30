class UsersController < ApplicationController
  layout "application", only: :new

  before_action :load_user, only: :show

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "controllers.users.signup_success"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :address,
      :password_confirmation, :phone_number
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controllers.users.user_not_found"
    redirect_to root_path
  end
end
