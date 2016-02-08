require 'rails_helper'

RSpec.describe SearchSuggestionsController, type: :controller do
  let(:user) { build(:user) }

  describe '#index' do
    before(:each) do
      log_in_as(user)
      allow(SearchSuggestion)
        .to receive(:terms_for)
        .and_return(foo: 'bar')
      term = '_term'
      parent_set = '_parent_set'
      get(:index, term: term, parent_set: parent_set)
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'calls SearchSuggestion.terms_for' do
      expect(SearchSuggestion).to have_received(:terms_for)
    end
    it 'renders json' do
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end
end
