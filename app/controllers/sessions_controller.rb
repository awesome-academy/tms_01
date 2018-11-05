class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    check_sign_in user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def check_sign_in user
    if user&.authenticate(params[:session][:password])
      log_in user
      if params[:session][:remember_me] == Settings.sessions.check_session
        remember user
      else
        forget user
      end
      redirect_after_sign_in user
    else
      flash.now[:danger] = t "controllers.sessions.invalid_account"
      render :new
    end
  end

  def redirect_after_sign_in user
    url = user.supervisor? ? user : basic_trainee_user_path(user)
    redirect_to url
  end
end
