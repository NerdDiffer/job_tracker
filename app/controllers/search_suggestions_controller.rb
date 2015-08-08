class SearchSuggestionsController < ApplicationController
  before_action :logged_in_user
  def index
    # params[:term] is set up jQueryUI/autocomplete
    # params[:parent_set] is set by coffeescript
    render json: SearchSuggestion.terms_for(params[:term],
                                            :parent_set => params[:parent_set])
  end
end
