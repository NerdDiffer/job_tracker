require 'rails_helper'

describe HomeController, type: :routing do
  describe 'routing' do
    it 'root routes to #index' do
      expect(get: '/').to route_to('home#index')
    end
    it 'routes to #about' do
      expect(get: '/about').to route_to('home#about')
    end
  end
end
