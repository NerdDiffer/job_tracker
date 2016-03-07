require 'rails_helper'

describe SearchSuggestionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/search_suggestions').to route_to('search_suggestions#index')
    end
  end
end
