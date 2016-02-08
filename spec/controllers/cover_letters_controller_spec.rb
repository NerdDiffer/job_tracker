require 'rails_helper'

RSpec.describe CoverLettersController, type: :controller do
  let(:user) { build(:user, id: 1) }
  let(:cover_letter) { build(:cover_letter) }
  let(:job_application) { build(:job_application) }

  before(:each) { log_in_as(user) }

  describe 'GET #index' do
    before(:each) do
      allow(CoverLetter).to receive(:sorted).and_return(cover_letter)
      allow(@controller).to receive(:custom_index_sort).and_return([cover_letter])
      get(:index, sort: true)
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns all cover_letters as @cover_letters' do
      expect(assigns(:cover_letters)).to eq([cover_letter])
    end
    it 'renders index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before(:each) do
      allow(CoverLetter).to receive(:find).and_return(cover_letter)
      get(:show, id: 'joe-schmoe')
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested cover_letter as @cover_letter' do
      expect(assigns(:cover_letter)).to eq(cover_letter)
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
    it 'assigns a new cover_letter as @cover_letter' do
      expect(assigns(:cover_letter)).to be_a_new(CoverLetter)
    end
  end

  describe 'GET #edit' do
    before(:each) do
      allow(CoverLetter).to receive(:find).and_return(cover_letter)
      get(:edit, id: 'joe-schmoe')
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested company as @cover_letter' do
      expect(assigns(:cover_letter)).to eq(cover_letter)
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
      allow(CoverLetter).to receive(:new).and_return(cover_letter)
    end

    context 'with valid params' do
      before(:each) do
        allow(cover_letter).to receive(:save).and_return(true)
        post(:create, cover_letter: attr_for_create)
      end

      it 'sets @cover_letter to a new CoverLetter object' do
        expect(assigns(:cover_letter)).to be_a_new(CoverLetter)
      end
      it 'redirects to the created cover_letter' do
        expect(response).to redirect_to(cover_letter)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(cover_letter).to receive(:save).and_return(false)
        post(:create, cover_letter: attr_for_create)
      end

      it 'assigns a newly created but unsaved cover_letter as @cover_letter' do
        expect(assigns(:cover_letter)).to be_a_new(CoverLetter)
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
        cover_letter: { job_application_id: 2 }
      }
    end

    before(:each) do
      allow(CoverLetter).to receive(:find).and_return(cover_letter)
    end

    context 'with valid params' do
      before(:each) do
        allow(cover_letter).to receive(:update).and_return(true)
      end

      it 'assigns the requested cover_letter as @cover_letter' do
        put(:update, attr_for_update)
        expect(assigns(:cover_letter)).to eq(cover_letter)
      end

      it 'calls update on the requested cover_letter' do
        expect(cover_letter).to receive(:update)
        put(:update, attr_for_update)
      end

      it 'redirects to the cover_letter' do
        put(:update, attr_for_update)
        expect(response).to redirect_to(cover_letter)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(cover_letter).to receive(:update).and_return(false)
        put(:update, attr_for_update)
      end

      it 'assigns the cover_letter as @cover_letter' do
        expect(assigns(:cover_letter)).to eq(cover_letter)
      end

      it 're-renders the "edit" template' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      allow(CoverLetter).to receive(:find).and_return(cover_letter)
    end

    it 'calls destroy on the requested cover_letter' do
      expect(cover_letter).to receive(:destroy)
      delete(:destroy, id: 1)
    end

    it 'redirects to the cover_letters list' do
      delete(:destroy, id: 1)
      expect(response).to redirect_to(cover_letters_url)
    end
  end
end
