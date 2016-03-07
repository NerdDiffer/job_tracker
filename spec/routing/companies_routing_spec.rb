require 'rails_helper'

RSpec.describe CompaniesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/companies').to route_to('companies#index')
    end

    it 'routes to #new' do
      expect(get: '/companies/new').to route_to('companies#new')
    end

    it 'routes to #show' do
      expect(get: '/companies/1').to route_to('companies#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/companies').to route_to('companies#create')
    end
  end
end
