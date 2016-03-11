require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/profile').to route_to('users#show')
    end

    it 'routes to #destroy' do
      expect(delete: '/profile').to route_to('users#destroy')
    end
  end
end
