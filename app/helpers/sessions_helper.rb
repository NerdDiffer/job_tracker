module SessionsHelper

  # @return currently logged-in user, if there is one at all
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # @return true, if the given user is the current user
  def current_user?(user)
    user == current_user
  end

  # log in a user
  def log_in(user)
    session[:user_id] = user.id
  end

  # log out the user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # remember a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # forget a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # check that a user is logged in
  # @return true, if a user is logged in
  # @return false, if a user is not logged in
  def logged_in?
    !current_user.nil?
  end

  # redirects to stored location (or to default location)
  def redirect_back_or(default)
    # redirects do not happen until there's an explicit return or end of method
    # if forwarding_url is nil, then go to the passed-in location (default)
    redirect_to(session[:forwarding_url] || default)
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
        flash[:danger] = "Please log in"
        redirect_to login_url
        false # halt the before filter
      end
    end
end
