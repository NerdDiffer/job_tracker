require 'rails_helper'

RSpec.describe CoverLettersController, type: :controller do
  let(:user) { build(:user, id: 1) }
  let(:cover_letter) { build(:cover_letter) }
  let(:job_application) { build(:job_application) }

  before(:each) { log_in_as(user) }

  describe 'GET #index' do
    let(:relation) do
      ActiveRecord::Relation.new(CoverLetter, 'cover_letters')
    end

    before(:each) do
      allow(controller)
        .to receive(:collection_belonging_to_user)
        .and_return(relation)
      allow(CoverLetter).to receive(:sorted).and_return(cover_letter)
      allow(controller)
        .to receive(:custom_index_sort)
        .and_return([cover_letter])
    end

    describe 'functional tests' do
      before(:each) do
        get(:index, sort: true)
      end

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end
      it 'assigns all cover_letters as @cover_letters' do
        expect(assigns(:cover_letters)).not_to be_nil
      end
      it 'renders index' do
        expect(response).to render_template(:index)
      end
    end

    describe 'expected method calls' do
      after(:each) do
        get(:index, sort: true)
      end

      it 'calls #collection_belonging_to_user' do
        expect(controller).to receive(:collection_belonging_to_user)
      end
      it 'calls .sorted' do
        expect(CoverLetter).to receive(:sorted)
      end
      it 'calls #custom_index_sort' do
        expect(controller).to receive(:custom_index_sort)
      end
    end
  end

  describe 'GET #show' do
    before(:each) do
      stub_before_actions
      get(:show, job_application_id: 1)
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
      stub_before_actions
      get(:edit, job_application_id: 1)
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
        cover_letter: {
          first_name: 'Foo',
          last_name: 'Bar',
          title: '_title',
        },
        job_application_id: 1
      }
    end

    before(:each) do
      allow(controller)
        .to receive(:cover_letter_params_with_associated_ids)
        .and_return(attr_for_create)
    end

    context 'expected method calls' do
      before(:each) do
        allow(controller).to receive(:respond_to).and_return(true)
        allow(controller).to receive(:render).and_return(true)
        allow(CoverLetter).to receive(:new).and_return(cover_letter)
      end
      after(:each) do
        post(:create, attr_for_create)
      end

      it 'calls #cover_letter_params_with_associated_ids' do
        expect(controller).to receive(:cover_letter_params_with_associated_ids)
      end
      it 'calls .new on CoverLetter' do
        expect(CoverLetter).to receive(:new).with(attr_for_create)
      end
    end

    context 'with valid params' do
      before(:each) do
        allow(cover_letter).to receive(:job_application).and_return(job_application)
        allow(cover_letter).to receive(:save).and_return(true)
        allow(controller).to receive(:render).and_return(true)
        allow(CoverLetter).to receive(:new).and_return(cover_letter)
        post(:create, attr_for_create)
      end

      it 'sets @cover_letter to a new CoverLetter object' do
        expect(assigns(:cover_letter)).to be_a_new(CoverLetter)
      end
      it 'redirects to the created cover_letter' do
        expect(response).to redirect_to(cover_letter.job_application)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(cover_letter).to receive(:save).and_return(false)
        allow(CoverLetter).to receive(:new).and_return(cover_letter)
        post(:create, attr_for_create)
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
        cover_letter: { content: '' },
        job_application_id: 2
      }
    end

    before(:each) do
      stub_before_actions
    end

    context 'with valid params' do
      before(:each) do
        allow(cover_letter).to receive(:update).and_return(true)
        allow(cover_letter).to receive(:job_application).and_return(job_application)
        allow(cover_letter).to receive(:update).and_return(true)
        allow(controller).to receive(:render).and_return(true)
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
        expect(response).to redirect_to(cover_letter.job_application)
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
      allow(cover_letter).to receive(:job_application).and_return(job_application)
      allow(cover_letter).to receive(:destroy).and_return(true)
      stub_before_actions
    end

    it 'calls destroy on the requested cover_letter' do
      expect(cover_letter).to receive(:destroy)
      delete(:destroy, job_application_id: 1)
    end

    it 'redirects to the cover_letters list' do
      delete(:destroy, job_application_id: 1)
      expect(response).to redirect_to(cover_letter.job_application)
    end
  end

  describe '#cover_letter_params_with_associated_ids' do
    let(:params) { { job_application_id: 1 } }

    before(:each) do
      allow(controller).to receive(:params).and_return(params)
      allow(controller)
        .to receive(:cover_letter_params)
        .and_return({})
    end
    after(:each) do
      controller.send(:cover_letter_params_with_associated_ids)
    end

    it 'calls #cover_letter_params' do
      expect(controller).to receive(:cover_letter_params)
    end
    it 'calls #merge on contact_params' do
      cover_letter_params = controller.send(:cover_letter_params)
      expected_args = { job_application_id: 1 }
      expect(cover_letter_params).to receive(:merge).with(expected_args)
    end
  end

  private

  def stub_before_actions
    allow(controller).to receive(:set_cover_letter)
    allow(controller).to receive(:check_user)
    allow(controller).to receive(:cover_letter).and_return(cover_letter)
    controller.instance_eval { @cover_letter = cover_letter }
  end
end
