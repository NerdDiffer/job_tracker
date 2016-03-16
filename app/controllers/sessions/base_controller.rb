module Sessions
  class BaseController < ApplicationController
    attr_reader :user

    def destroy
      log_out if logged_in?
      flash[:notice] = 'You have logged out'
      redirect_to(root_url)
    end
  end
end
