class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :sort_direction

  include SessionsHelper

  private

    # Used in sorting search results in various #index views
    def sort_direction
      # allow only 'asc' or 'desc' values
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end

end
