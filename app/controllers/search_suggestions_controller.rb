class SearchSuggestionsController < ApplicationController
  before_action :logged_in_user
  def index
    render json: SearchSuggestion.terms_for(params[:term])
  end
end
