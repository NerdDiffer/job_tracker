class SessionsController < ApplicationController
  def new
    unless logged_in?
      # display login page
    else
      # if already logged in, then go to user profile
      redirect_to(current_user)
    end
  end

  def create
    if params[:session][:email].present? && params[:session][:password].present?
      user = User.find_by(email: params[:session][:email].downcase)
    end

    if user && user.authenticate(params[:session][:password])
      log_in(user)
      flash[:success] = "You are now logged in"
      params[:session][:remember_me] == '1' ?
        remember(user) :
        forget(user)
      redirect_back_or(user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:notice] = "You have logged out"
    redirect_to(root_url)
  end
end
