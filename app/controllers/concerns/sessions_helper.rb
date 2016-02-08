module SessionsHelper
  # @return currently logged-in user, if there is one at all
  def current_user
    if session[:user_id]
      @current_user ||= find_user_with_session
    elsif cookies.signed[:user_id]
      user = find_user_with_signed_cookie
      if user && authenticated_user?(user)
        log_in(user)
        @current_user = user
      end
    end
  end

  # @return true, if the given user is the current user
  def current_user?(user)
    user == current_user
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # check that a user is logged in
  # @return true if a user is logged in
  # @return false if a user is not logged in
  def logged_in?
    !current_user.nil?
  end

  # redirects to stored location (or to a default location)
  def redirect_back_or(default)
    # redirects do not happen until there's an explicit return or end of method
    # if forwarding_url is nil, then go to the passed-in location (default)
    forwarding_url = session[:forwarding_url]
    redirect_to(forwarding_url || default)
    session.delete(:forwarding_url)
  end

  # stores url that you are trying to access
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  private

  # confirm a logged-in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in'
      redirect_to(login_url)
      false # halt the before filter
    end
  end

  def find_user_with_session
    id = session[:user_id]
    User.find_by(id: id)
  end

  def find_user_with_signed_cookie
    id = cookies.signed[:user_id]
    User.find_by(id: id)
  end

  def authenticated_user?(user)
    token = cookies[:remember_token]
    user.authenticated?(:remember, token)
  end
end
