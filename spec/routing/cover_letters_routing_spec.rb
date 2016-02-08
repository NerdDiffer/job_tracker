require 'rails_helper'

RSpec.describe CoverLettersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/cover_letters').to route_to('cover_letters#index')
    end

    it 'routes to #new' do
      expect(get: '/cover_letters/new').to route_to('cover_letters#new')
    end

    it 'routes to #show' do
      expect(get: '/cover_letters/1').to route_to('cover_letters#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/cover_letters/1/edit').to route_to('cover_letters#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/cover_letters').to route_to('cover_letters#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/cover_letters/1').to route_to('cover_letters#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/cover_letters/1').to route_to('cover_letters#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/cover_letters/1').to route_to('cover_letters#destroy', id: '1')
    end
  end
end
