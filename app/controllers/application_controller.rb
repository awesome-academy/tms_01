class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?
    flash[:danger] = t "controllers.users.pls_log_in"
    redirect_to login_path
  end

  def supervisor_user
    redirect_to(login_path) unless current_user.supervisor?
  end
end
