require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  let(:user) { build(:user, id: 1) }
  let(:contact) { build(:contact) }
  let(:company) { build(:company) }

  before(:each) { log_in_as(user) }

  describe 'GET #index' do
    before(:each) do
      allow(Contact).to receive(:sorted).and_return(contact)
      allow(@controller).to receive(:custom_index_sort).and_return([contact])
      get(:index, sort: true)
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns all contacts as @contacts' do
      expect(assigns(:contacts)).to eq([contact])
    end
    it 'renders index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before(:each) do
      allow(Contact).to receive(:find).and_return(contact)
      get(:show, id: 'joe-schmoe')
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested contact as @contact' do
      expect(assigns(:contact)).to eq(contact)
    end
    it 'renders show' do
      expect(response).to render_template(:show)
    end

    context '@notable, @notes, @note' do
      it 'assigns @contact to @notable' do
        expect(assigns(:notable)).to eq(assigns(:contact))
      end
      it 'assigns @notes to @notable.notes' do
        expected = Note::ActiveRecord_Associations_CollectionProxy
        expect(assigns(:notes)).to be_instance_of(expected)
      end
      it 'assigns @note to a new instance of Note' do
        expect(assigns(:note)).to be_a_new Note
      end
    end
  end

  describe 'GET #new' do
    before(:each) do
      get(:new, company_id: 1)
    end

    it 'returns a 200' do
      expect(response.code).to eq '200'
    end
    it 'assigns a new contact as @contact' do
      expect(assigns(:contact)).to be_a_new(Contact)
    end
  end

  describe 'GET #edit' do
    before(:each) do
      allow(Contact).to receive(:find).and_return(contact)
      get(:edit, id: 'joe-schmoe')
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested company as @contact' do
      expect(assigns(:contact)).to eq(contact)
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
        company_name: company.name
      }
    end

    before(:each) do
      allow(Company).to receive(:find).and_return(company)
      allow(Contact).to receive(:new).and_return(contact)
    end

    context 'with valid params' do
      before(:each) do
        allow(contact).to receive(:save).and_return(true)
        post(:create, contact: attr_for_create)
      end

      it 'sets @contact to a new Contact object' do
        expect(assigns(:contact)).to be_a_new(Contact)
      end
      it 'redirects to the created contact' do
        expect(response).to redirect_to(contact)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(contact).to receive(:save).and_return(false)
        post(:create, contact: attr_for_create)
      end

      it 'assigns a newly created but unsaved contact as @contact' do
        expect(assigns(:contact)).to be_a_new(Contact)
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
        contact: {
          first_name: 'Bar',
          last_name: 'foo'
        }
      }
    end

    before(:each) do
      allow(Contact).to receive(:find).and_return(contact)
    end

    context 'with valid params' do
      before(:each) do
        allow(contact).to receive(:update).and_return(true)
      end

      it 'assigns the requested contact as @contact' do
        put(:update, attr_for_update)
        expect(assigns(:contact)).to eq(contact)
      end

      it 'calls update on the requested contact' do
        expect(contact).to receive(:update)
        put(:update, attr_for_update)
      end

      it 'redirects to the contact' do
        put(:update, attr_for_update)
        expect(response).to redirect_to(contact)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(contact).to receive(:update).and_return(false)
        put(:update, attr_for_update)
      end

      it 'assigns the contact as @contact' do
        expect(assigns(:contact)).to eq(contact)
      end

      it 're-renders the "edit" template' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      allow(Contact).to receive(:find).and_return(contact)
    end

    it 'calls destroy on the requested contact' do
      expect(contact).to receive(:destroy)
      delete(:destroy, id: 'joe-schmoe')
    end

    it 'redirects to the contacts list' do
      delete(:destroy, id: 'joe-schmoe')
      expect(response).to redirect_to(contacts_url)
    end
  end
end
