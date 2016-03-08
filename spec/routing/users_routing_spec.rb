require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/profile/new').to route_to('users#new')
    end

    it 'routes to #show' do
      expect(get: '/profile').to route_to('users#show')
    end

    it 'routes to #edit' do
      expect(get: '/profile/edit').to route_to('users#edit')
    end

    it 'routes to #create' do
      expect(post: '/profile').to route_to('users#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/profile').to route_to('users#update')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/profile').to route_to('users#update')
    end

    it 'routes to #destroy' do
      expect(delete: '/profile').to route_to('users#destroy')
    end
  end
end
