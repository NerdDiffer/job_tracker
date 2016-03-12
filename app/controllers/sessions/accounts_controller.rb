class Sessions::AccountsController < Sessions::BaseController
  before_action :set_account, only: :create
  before_action :set_user,    only: :create

  attr_reader :account

  def new
    return redirect_to(user_path) if logged_in?
    # otherwise, display login page
  end

  def create
    if authenticated?
      login_authenticated_user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  private

  def set_account
    @account = find_account_by_email if email_and_password?
  end

  def set_user
    @user = account.user rescue nil
  end

  def email_and_password?
    email? && password?
  end

  def email?
    params[:session][:email].present?
  end

  def password?
    params[:session][:password].present?
  end

  def find_account_by_email
    email = params[:session][:email].downcase
    Users::Account.find_by(email: email)
  end

  def authenticated?
    password = params[:session][:password]
    user && user.authenticate(password)
  end

  def login_authenticated_user
    log_in(user)
    flash[:success] = 'You are now logged in'

    if remember_me?
      remember(user)
    else
      forget(user)
    end

    redirect_back_or(user_path)
  end

  def remember_me?
    remember_me = params[:session][:remember_me]
    remember_me == '1'
  end
end
