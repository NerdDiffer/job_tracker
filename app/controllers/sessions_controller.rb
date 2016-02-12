class SessionsController < ApplicationController
  def new
    return redirect_to(current_user) if logged_in?
    # otherwise, display login page
  end

  def create
    user = find_user_by_email if email_and_password?

    if authenticated?(user)
      login_authenticated_user(user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:notice] = 'You have logged out'
    redirect_to(root_url)
  end

  private

  def email_and_password?
    email? && password?
  end

  def email?
    params[:session][:email].present?
  end

  def password?
    params[:session][:password].present?
  end

  def find_user_by_email
    email = params[:session][:email].downcase
    User.find_by(email: email)
  end

  def authenticated?(user)
    password = params[:session][:password]
    user && user.authenticate(password)
  end

  def login_authenticated_user(user)
    log_in(user)
    flash[:success] = 'You are now logged in'

    if remember_me?
      remember(user)
    else
      forget(user)
    end

    redirect_back_or(user)
  end

  def remember_me?
    remember_me = params[:session][:remember_me]
    remember_me == '1'
  end
end
