require 'rails_helper'

RSpec.describe CoverLettersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/cover_letters').to route_to('cover_letters#index')
    end
    it 'routes to #new' do
      expected = { controller: 'cover_letters', action: 'new',
                   job_application_id: '1' }
      expect(get: '/job_applications/1/cover_letter/new').to route_to(expected)
    end
    it 'routes to #show' do
      expected = { controller: 'cover_letters', action: 'show',
                   job_application_id: '1' }
      expect(get: '/job_applications/1/cover_letter').to route_to(expected)
    end
    it 'routes to #edit' do
      expected = { controller: 'cover_letters', action: 'edit',
                   job_application_id: '1' }
      expect(get: '/job_applications/1/cover_letter/edit').to route_to(expected)
    end
    it 'routes to #create' do
      expected = { controller: 'cover_letters', action: 'create',
                   job_application_id: '1' }
      expect(post: '/job_applications/1/cover_letter').to route_to(expected)
    end
    it 'routes to #update via PUT' do
      expected = { controller: 'cover_letters', action: 'update',
                   job_application_id: '1' }
      expect(put: '/job_applications/1/cover_letter').to route_to(expected)
    end
    it 'routes to #update via PATCH' do
      expected = { controller: 'cover_letters', action: 'update',
                   job_application_id: '1' }
      expect(patch: '/job_applications/1/cover_letter').to route_to(expected)
    end
    it 'routes to #destroy' do
      expected = { controller: 'cover_letters', action: 'destroy',
                   job_application_id: '1' }
      expect(delete: '/job_applications/1/cover_letter').to route_to(expected)
    end
  end
end
