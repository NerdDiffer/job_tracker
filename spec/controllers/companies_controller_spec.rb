require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:user) { build(:user, id: 1) }
  let(:company) { build(:company) }

  before(:each) { log_in_as(user) }

  describe 'GET #index' do
    before(:each) do
      allow(@controller)
        .to receive(:search_and_sort_index)
        .and_return([:foo, :bar])
      get(:index)
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns all companies as @companies' do
      expect(assigns(:companies)).to eq([:foo, :bar])
    end
    it 'renders index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before(:each) do
      allow(Company).to receive(:find).and_return(company)
      get(:show, id: 'example-company')
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested company as @company' do
      expect(assigns(:company)).to eq(company)
    end
    it 'renders show' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new company as @company' do
      get(:new)
      expect(assigns(:company)).to be_a_new(Company)
    end
  end

  describe 'GET #edit' do
    before(:each) do
      allow(Company).to receive(:find).and_return(company)
      get :edit, id: 'example-company'
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested company as @company' do
      expect(assigns(:company)).to eq(company)
    end
    it 'renders edit' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    let(:attr_for_create) do
      { name: 'foo', website: 'www.example.com', category: 'bar' }
    end

    before(:each) do
      allow(Company).to receive(:new).and_return(company)
    end

    context 'with valid params' do
      before(:each) do
        allow(company).to receive(:save).and_return(true)
        post(:create, company: attr_for_create)
      end

      it 'sets @company to a new Company object' do
        expect(assigns(:company)).to be_a_new(Company)
      end
      it 'redirects to the created company' do
        expect(response).to redirect_to(company)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(company).to receive(:save).and_return(false)
        post(:create, company: attr_for_create)
      end

      it 'assigns a newly created but unsaved company as @company' do
        expect(assigns(:company)).to be_a_new(Company)
      end

      it 're-renders the "new" template' do
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    let(:attr_for_update) do
      {
        id: company.name,
        company: {
          name: 'foo',
          category: 'bar'
        }
      }
    end

    before(:each) do
      allow(Company).to receive(:find).and_return(company)
    end

    context 'with valid params' do
      before(:each) do
        allow(company).to receive(:update).and_return(true)
      end

      it 'assigns the requested company as @company' do
        put(:update, attr_for_update)
        expect(assigns(:company)).to eq(company)
      end
      it 'updates the requested company' do
        expect(company).to receive(:update)
        put(:update, attr_for_update)
      end
      it 'redirects to the company' do
        put(:update, attr_for_update)
        expect(response).to redirect_to(company)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(company).to receive(:update).and_return(false)
        put(:update, attr_for_update)
      end

      it 'assigns the company as @company' do
        expect(assigns(:company)).to eq(company)
      end
      it 're-renders the "edit" template' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      allow(Company).to receive(:find).and_return(company)
    end

    it 'calls destroy on the requested company' do
      expect(company).to receive(:destroy)
      delete(:destroy, id: 'example-company')
    end
    it 'redirects to the companies list' do
      delete(:destroy, id: 'example-company')
      expect(response).to redirect_to(companies_url)
    end
  end
end
