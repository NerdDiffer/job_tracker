require 'rails_helper'

describe HomeController, type: :routing do
  describe 'routing' do
    it 'root routes to #index' do
      expect(get: '/').to route_to('home#index')
    end
  end
end
