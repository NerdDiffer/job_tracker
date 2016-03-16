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

describe Sessions::OmniAuthUsersController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expected = { controller: 'sessions/omni_auth_users',
                   action: 'create', provider: 'name_of_provider' }
      expect(get: '/auth/name_of_provider/callback').to route_to(expected)
    end

    it 'routes to #failure' do
      expect(get: '/auth/failure').to route_to('sessions/omni_auth_users#failure')
    end
  end
end
