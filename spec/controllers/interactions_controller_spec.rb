require 'rails_helper'

RSpec.describe InteractionsController, type: :controller do
  let(:user) { build(:user, id: 1) }
  let(:interaction) { build(:interaction) }
  let(:contact) { build(:contact) }

  before(:each) { log_in_as(user) }

  describe 'GET #index' do
    before(:each) do
      allow(Interaction).to receive(:sorted).and_return(interaction)
      allow(@controller).to receive(:custom_index_sort).and_return([interaction])
      get(:index, sort: true)
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns all interactions as @interactions' do
      expect(assigns(:interactions)).to eq([interaction])
    end
    it 'renders index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before(:each) do
      allow(Interaction).to receive(:find).and_return(interaction)
      get(:show, id: 'joe-schmoe')
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested interaction as @interaction' do
      expect(assigns(:interaction)).to eq(interaction)
    end
    it 'renders show' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before(:each) do
      get(:new, contact_id: 1)
    end

    it 'returns a 200' do
      expect(response.code).to eq '200'
    end
    it 'assigns a new interaction as @interaction' do
      expect(assigns(:interaction)).to be_a_new(Interaction)
    end
  end

  describe 'GET #edit' do
    before(:each) do
      allow(Interaction).to receive(:find).and_return(interaction)
      get(:edit, id: 1)
    end

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
    it 'assigns the requested company as @interaction' do
      expect(assigns(:interaction)).to eq(interaction)
    end
    it 'renders edit' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    let(:attr_for_create) do
      {
        notes: '', medium: 0, approx_date: Time.now
      }
    end

    before(:each) do
      allow(Contact).to receive(:find).and_return(contact)
      allow(Interaction).to receive(:new).and_return(interaction)
      allow(@controller).to receive(:set_contact_id).and_return(1)
    end

    context 'with valid params' do
      before(:each) do
        allow(interaction).to receive(:save).and_return(true)
        post(:create, interaction: attr_for_create)
      end

      it 'sets @interaction to a new Interaction object' do
        expect(assigns(:interaction)).to be_a_new(Interaction)
      end
      it 'redirects to the created interaction' do
        expect(response).to redirect_to(interaction)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(interaction).to receive(:save).and_return(false)
        post(:create, interaction: attr_for_create)
      end

      it 'assigns a newly created but unsaved interaction as @interaction' do
        expect(assigns(:interaction)).to be_a_new(Interaction)
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
        interaction: { notes: 'bar', },
        contact_name: 'arnold'
      }
    end

    before(:each) do
      allow(Interaction).to receive(:find).and_return(interaction)
      allow(@controller).to receive(:set_contact_id).and_return(1)
    end

    context 'with valid params' do
      before(:each) do
        allow(interaction).to receive(:update).and_return(true)
      end

      it 'assigns the requested interaction as @interaction' do
        put(:update, attr_for_update)
        expect(assigns(:interaction)).to eq(interaction)
      end

      it 'calls update on the requested interaction' do
        expect(interaction).to receive(:update)
        put(:update, attr_for_update)
      end

      it 'redirects to the interaction' do
        put(:update, attr_for_update)
        expect(response).to redirect_to(interaction)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(interaction).to receive(:update).and_return(false)
        put(:update, attr_for_update)
      end

      it 'assigns the interaction as @interaction' do
        expect(assigns(:interaction)).to eq(interaction)
      end

      it 're-renders the "edit" template' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      allow(Interaction).to receive(:find).and_return(interaction)
    end

    it 'calls destroy on the requested interaction' do
      expect(interaction).to receive(:destroy)
      delete(:destroy, id: 1)
    end

    it 'redirects to the interactions list' do
      delete(:destroy, id: 1)
      expect(response).to redirect_to(interactions_url)
    end
  end

  describe '#set_contact' do
    mock_params = { contact_name: 'foo bar' }

    before(:each) do
      allow(contact).to receive(:id).and_return(1)
      allow(Contact).to receive(:get_record_val_by).and_return(contact.id)
      allow(@controller).to receive(:params).and_return(mock_params)
    end

    it 'calls Contact.get_record_val_by' do
      expect(Contact).to receive(:get_record_val_by).with(:name, 'foo bar')
      @controller.send(:set_contact_id)
    end
    it 'returns the id of the contact object' do
      actual = @controller.send(:set_contact_id)
      expect(actual).to eq 1
    end
  end

  describe '#interaction_params_with_company_id!' do
    params = ActionController::Parameters.new({
      interaction: { active: true }
    })

    before(:each) do
      allow(@controller).to receive(:set_contact_id).and_return(1)
      allow(@controller).to receive(:interaction_params).and_return(params)
    end

    it 'merges with this hash' do
      expect(@controller.send(:interaction_params))
        .to receive(:merge!)
        .with(contact_id: 1)
      @controller.send(:interaction_params_with_contact_id!)
    end
  end
end
