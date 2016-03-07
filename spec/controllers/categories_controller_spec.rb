require 'rails_helper'

describe CategoriesController, type: :controller do
  let(:category) { build(:category) }

  describe 'GET #index' do
    let(:categories) { double('categories') }

    before(:each) do
      allow(Category).to receive(:all).and_return(categories)
    end

    it 'calls .all on Category' do
      expect(Category).to receive(:all)
      get :index
    end
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
    it 'sets value for @categories' do
      get :index
      expect(assigns(:categories)).to eq categories
    end
  end

  describe 'GET #show' do
    let(:companies) { %I(foo bar) }

    before(:each) do
      allow(controller).to receive(:set_category)
      allow(category).to receive(:companies).and_return(companies)
      allow(controller).to receive(:category).and_return(category)
    end

    it 'the category is not nil' do
      expect(controller).to receive(:category)
      get :show, id: 1
    end
    it 'calls #companies on the category' do
      expect(category).to receive(:companies)
      get :show, id: 1
    end
    it 'returns http success' do
      get :show, id: 1
      expect(response).to have_http_status(:success)
    end
    it 'sets value for @companies' do
      get :show, id: 1
      expect(assigns(:companies)).to eq companies
    end
  end

  describe '#set_category' do
    let(:params) { { id: 1 } }

    before(:each) do
      allow(controller).to receive(:params).and_return(params)
      allow(Category).to receive(:find).and_return(category)
    end

    it 'calls .find on Category' do
      expect(Category).to receive(:find).with(1)
      controller.send(:set_category)
    end
    it 'sets value for @category' do
      controller.send(:set_category)
      expect(assigns(:category)).to eq category
    end
  end
end
