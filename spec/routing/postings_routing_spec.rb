require 'rails_helper'

RSpec.describe PostingsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/postings').to route_to('postings#index')
    end
    it 'routes to #new' do
      expected = { controller: 'postings', action: 'new',
                   job_application_id: '1' }
      expect(get: '/job_applications/1/posting/new').to route_to(expected)
    end
    it 'routes to #show' do
      expected = { controller: 'postings', action: 'show',
                   job_application_id: '1' }
      expect(get: '/job_applications/1/posting').to route_to(expected)
    end
    it 'routes to #edit' do
      expected = { controller: 'postings', action: 'edit',
                   job_application_id: '1' }
      expect(get: '/job_applications/1/posting/edit').to route_to(expected)
    end
    it 'routes to #create' do
      expected = { controller: 'postings', action: 'create',
                   job_application_id: '1' }
      expect(post: '/job_applications/1/posting').to route_to(expected)
    end
    it 'routes to #update via PUT' do
      expected = { controller: 'postings', action: 'update',
                   job_application_id: '1' }
      expect(put: '/job_applications/1/posting').to route_to(expected)
    end
    it 'routes to #update via PATCH' do
      expected = { controller: 'postings', action: 'update',
                   job_application_id: '1' }
      expect(patch: '/job_applications/1/posting').to route_to(expected)
    end
    it 'routes to #destroy' do
      expected = { controller: 'postings', action: 'destroy',
                   job_application_id: '1' }
      expect(delete: '/job_applications/1/posting').to route_to(expected)
    end
  end
end
