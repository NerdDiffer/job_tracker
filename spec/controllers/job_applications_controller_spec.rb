require 'rails_helper'

RSpec.describe JobApplicationsController, type: :controller do
  let(:user) { build(:user, id: 1) }
  let(:job_application) { build(:job_application) }
  let(:company) { build(:company) }
  let(:posting) { build(:posting) }
  let(:cover_letter) { build(:cover_letter) }

  before(:each) { log_in_as(user) }

  describe 'GET #index' do
    relation = ActiveRecord::Relation.new(JobApplication, 'job_applications')

    before(:each) do
      allow(JobApplication)
        .to receive(:filter)
        .and_return(relation)
      allow(JobApplication)
        .to receive(:sorted)
        .and_return(job_application)
      allow(@controller)
        .to receive(:custom_index_sort)
        .and_return([job_application])
      get(:index, sort: true)
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns all job_applications as @job_application' do
      expect(assigns(:job_applications)).to eq([job_application])
    end
    it 'renders index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before(:each) do
      allow(JobApplication).to receive(:find).and_return(job_application)
      get(:show, id: 1)
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested job_application as @job_application' do
      expect(assigns(:job_application)).to eq(job_application)
    end
    it 'renders show' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before(:each) do
      get(:new, company_id: 1)
    end

    it 'returns a 200' do
      expect(response.code).to eq '200'
    end
    it 'assigns a new job_application as @posting' do
      expect(assigns(:job_application)).to be_a_new(JobApplication)
    end
  end

  describe 'GET #edit' do
    before(:each) do
      allow(JobApplication).to receive(:find).and_return(job_application)
      get(:edit, id: 1)
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested company as @job_application' do
      expect(assigns(:job_application)).to eq(job_application)
    end
    it 'renders edit' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    let(:attr_for_create) do
      { job_application: { active: true } }
    end

    before(:each) do
      allow(Company).to receive(:find).and_return(company)
      allow(JobApplication).to receive(:new).and_return(job_application)
    end

    context 'with valid params' do
      before(:each) do
        allow(job_application).to receive(:save).and_return(true)
        post(:create, job_application: attr_for_create)
      end

      it 'sets @job_application to a new JobApplication object' do
        expect(assigns(:job_application)).to be_a_new(JobApplication)
      end
      it 'redirects to the created job_application' do
        expect(response).to redirect_to(job_application)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(job_application).to receive(:save).and_return(false)
        post(:create, job_application: attr_for_create)
      end

      it 'assigns a newly created but unsaved job_application as @job_application' do
        expect(assigns(:job_application)).to be_a_new(JobApplication)
      end

      it 're-renders the "new" template' do
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    let(:attr_for_update) do
      {
        id: 1,
        job_application: { active: 'true' },
        company_name: 'example'
      }
    end

    before(:each) do
      allow(JobApplication).to receive(:find).and_return(job_application)
      allow(@controller).to receive(:set_company_id).and_return(1)
    end

    context 'with valid params' do
      before(:each) do
        allow(job_application).to receive(:update).and_return(true)
      end

      it 'assigns the requested job_application as @job_application' do
        put(:update, attr_for_update)
        expect(assigns(:job_application)).to eq(job_application)
      end

      it 'calls update on the requested job_application' do
        expect(job_application).to receive(:update)
        put(:update, attr_for_update)
      end

      it 'redirects to the job_application' do
        put(:update, attr_for_update)
        expect(response).to redirect_to(job_application)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(job_application).to receive(:update).and_return(false)
        put(:update, attr_for_update)
      end

      it 'assigns the job_application as @job_application' do
        expect(assigns(:job_application)).to eq(job_application)
      end

      it 're-renders the "edit" template' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      allow(JobApplication).to receive(:find).and_return(job_application)
    end

    it 'calls destroy on the requested job_application' do
      expect(job_application).to receive(:destroy)
      delete(:destroy, id: 1)
    end

    it 'redirects to the job_applications list' do
      delete(:destroy, id: 1)
      expect(response).to redirect_to(job_applications_url)
    end
  end

  describe '#set_company_id' do
    mock_params = { company_name: 'foo bar' }

    before(:each) do
      allow(company).to receive(:id).and_return(1)
      allow(Company).to receive(:get_record_val_by).and_return(company.id)
      allow(@controller).to receive(:params).and_return(mock_params)
    end

    it 'calls Company.get_record_val_by' do
      expect(Company).to receive(:get_record_val_by).with(:name, 'foo bar')
      @controller.send(:set_company_id)
    end
    it 'returns the id of the company object' do
      actual = @controller.send(:set_company_id)
      expect(actual).to eq 1
    end
  end

  describe '#job_application_params_with_company_id!' do
    params = ActionController::Parameters.new({
      job_application: { active: true }
    })

    before(:each) do
      allow(@controller).to receive(:set_company_id).and_return(1)
      allow(@controller).to receive(:job_application_params).and_return(params)
    end

    it 'merges with this hash' do
      expect(@controller.send(:job_application_params))
        .to receive(:merge!)
        .with(company_id: 1)
      @controller.send(:job_application_params_with_company_id!)
    end
  end
end
