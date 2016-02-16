class SearchSuggestionsController < ApplicationController
  before_action :logged_in_user

  def index
    term = params[:term] # set by jQueryUI/autocomplete
    base_key = params[:base_key] # set by coffeescript
    suggestions = SearchSuggestion.terms_for(term, base_key: base_key)
    render(json: suggestions)
  end
end
