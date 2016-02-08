class SearchSuggestionsController < ApplicationController
  before_action :logged_in_user

  def index
    term = params[:term] # set by jQueryUI/autocomplete
    parent_set = params[:parent_set] # set by coffeescript
    suggestions = SearchSuggestion.terms_for(term, parent_set: parent_set)
    render(json: suggestions)
  end
end
