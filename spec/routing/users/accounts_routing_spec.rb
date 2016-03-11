require 'rails_helper'

describe Users::AccountsController, type: :routing do
  describe 'routing' do
    it 'routes to #edit' do
      expected = { controller: 'users/accounts', action: 'edit' }
      expect(get: '/profile/account/edit').to route_to(expected)
    end
    it 'routes to #update via PUT' do
      expected = { controller: 'users/accounts', action: 'update' }
      expect(put: '/profile/account').to route_to(expected)
    end
  end
end
