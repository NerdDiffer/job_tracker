require 'rails_helper'

RSpec.describe PostingsController, type: :controller do
  let(:user) { build(:user, id: 1) }
  let(:posting) { build(:posting) }
  let(:job_application) { build(:job_application) }

  before(:each) { log_in_as(user) }

  describe 'GET #index' do
    before(:each) do
      allow(Posting).to receive(:sorted).and_return(posting)
      allow(@controller).to receive(:custom_index_sort).and_return([posting])
      get(:index, sort: true)
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns all postings as @postings' do
      expect(assigns(:postings)).to eq([posting])
    end
    it 'renders index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before(:each) do
      allow(Posting).to receive(:find).and_return(posting)
      get(:show, id: 'joe-schmoe')
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested posting as @posting' do
      expect(assigns(:posting)).to eq(posting)
    end
    it 'renders show' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before(:each) do
      get(:new, job_application_id: 1)
    end

    it 'returns a 200' do
      expect(response.code).to eq '200'
    end
    it 'assigns a new posting as @posting' do
      expect(assigns(:posting)).to be_a_new(Posting)
    end
  end

  describe 'GET #edit' do
    before(:each) do
      allow(Posting).to receive(:find).and_return(posting)
      get(:edit, id: 'joe-schmoe')
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested company as @posting' do
      expect(assigns(:posting)).to eq(posting)
    end
    it 'renders edit' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    let(:attr_for_create) do
      {
        first_name: 'Foo',
        last_name: 'Bar',
        title: '_title',
        job_application_id: 1
      }
    end

    before(:each) do
      allow(JobApplication).to receive(:find).and_return(job_application)
      allow(Posting).to receive(:new).and_return(posting)
    end

    context 'with valid params' do
      before(:each) do
        allow(posting).to receive(:save).and_return(true)
        post(:create, posting: attr_for_create)
      end

      it 'sets @posting to a new Posting object' do
        expect(assigns(:posting)).to be_a_new(Posting)
      end
      it 'redirects to the created posting' do
        expect(response).to redirect_to(posting)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(posting).to receive(:save).and_return(false)
        post(:create, posting: attr_for_create)
      end

      it 'assigns a newly created but unsaved posting as @posting' do
        expect(assigns(:posting)).to be_a_new(Posting)
      end

      it 're-renders the "new" template' do
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    let(:attr_for_update) do
      {
        id: 'foo-bar',
        posting: { job_application_id: 2 }
      }
    end

    before(:each) do
      allow(Posting).to receive(:find).and_return(posting)
    end

    context 'with valid params' do
      before(:each) do
        allow(posting).to receive(:update).and_return(true)
      end

      it 'assigns the requested posting as @posting' do
        put(:update, attr_for_update)
        expect(assigns(:posting)).to eq(posting)
      end

      it 'calls update on the requested posting' do
        expect(posting).to receive(:update)
        put(:update, attr_for_update)
      end

      it 'redirects to the posting' do
        put(:update, attr_for_update)
        expect(response).to redirect_to(posting)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(posting).to receive(:update).and_return(false)
        put(:update, attr_for_update)
      end

      it 'assigns the posting as @posting' do
        expect(assigns(:posting)).to eq(posting)
      end

      it 're-renders the "edit" template' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      allow(Posting).to receive(:find).and_return(posting)
    end

    it 'calls destroy on the requested posting' do
      expect(posting).to receive(:destroy)
      delete(:destroy, id: 1)
    end

    it 'redirects to the postings list' do
      delete(:destroy, id: 1)
      expect(response).to redirect_to(postings_url)
    end
  end
end
