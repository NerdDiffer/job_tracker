require 'rails_helper'

describe Sessions::BaseController, type: :routing do
  describe 'routing' do
    it 'routes to #destroy' do
      expect(delete: '/logout').to route_to('sessions/base#destroy')
    end
  end
end

describe Sessions::AccountsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/login').to route_to('sessions/accounts#new')
    end

    it 'routes to #create' do
      expect(post: '/login').to route_to('sessions/accounts#create')
    end
  end
end

describe Sessions::ProviderIdentitiesController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expected = 'sessions/provider_identities#create'
      expect(get: '/auth/twitter/callback').to route_to(expected)
    end

    it 'routes to #create' do
      expected = 'sessions/provider_identities#failure'
      expect(get: '/auth/failure').to route_to(expected)
    end
  end
end
