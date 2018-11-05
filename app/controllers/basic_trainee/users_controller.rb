class BasicTrainee::UsersController < ApplicationController
  layout "basic_application"
  before_action :logged_in_user
  before_action :load_user, only: %i(show edit update)

  def show; end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controllers.users.update_user"
      redirect_to root_path
    else
      render :edit
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
