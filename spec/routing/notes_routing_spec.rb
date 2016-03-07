require 'rails_helper'

# Most routes for NotesController are tested from inside of a host resource
RSpec.describe NotesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/notes').to route_to('notes#index')
    end
  end
end
