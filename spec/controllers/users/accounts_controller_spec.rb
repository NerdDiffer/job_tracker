require 'rails_helper'

describe Users::AccountsController, type: :controller do
  let(:account)  { build(:account) }
  let(:identity) { build(:identity) }
  let(:user)     { build(:user) }

  describe 'GET #new' do
    it 'assigns a new account as @account' do
      get(:new)
      expect(assigns(:account)).to be_a_new(Users::Account)
    end
    it 'renders the "new" template' do
      get(:new)
      expect(response).to render_template 'new'
    end
  end

  describe 'POST #create' do
    let(:attr_for_create) do
      {
        name: 'foobar', email: 'foobar@example.com',
        password: 'password', password_confirmation: 'password'
      }
    end

    before(:each) do
      allow(User).to receive(:new).and_return(user)
      allow(Users::Identity).to receive(:new).and_return(identity)
      allow(Users::Account).to receive(:new).and_return(account)
    end

    context 'with valid params' do
      before(:each) do
        allow(user).to receive(:id).and_return 1
        allow(controller).to receive(:user).and_return(user)
        allow(controller)
          .to receive(:assign_and_save_user_identities!)
          .and_return(true)
      end

      it 'calls #new_user_identity_account' do
        expect(controller).to receive(:new_user_identity_account)
        post(:create, users_account: attr_for_create)
      end
      it 'calls #assign_and_save_user_identities!' do
        expect(controller).to receive(:assign_and_save_user_identities!)
        post(:create, users_account: attr_for_create)
      end
      it 'calls #log_in' do
        expect(controller).to receive(:log_in).with(user)
        post(:create, users_account: attr_for_create)
      end
      it '@user is not nil' do
        post(:create, users_account: attr_for_create)
        expect(assigns(:user)).not_to be_nil
      end
      it 'redirects to the created user' do
        post(:create, users_account: attr_for_create)
        expect(response).to redirect_to(user_path)
      end
      it 'has a flash message' do
        post(:create, users_account: attr_for_create)
        expect(flash[:notice]).not_to be_nil
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(controller)
          .to receive(:assign_and_save_user_identities!)
          .and_return(false)
      end

      it 'calls #new_user_identity_account' do
        expect(controller).to receive(:new_user_identity_account)
        post(:create, users_account: attr_for_create)
      end
      it 'calls #assign_and_save_user_identities!' do
        expect(controller).to receive(:assign_and_save_user_identities!)
        post(:create, users_account: attr_for_create)
      end
      it 'calls #log_in' do
        expect(controller).not_to receive(:log_in)
        post(:create, users_account: attr_for_create)
      end
      it 're-renders the "new" template' do
        post(:create, users_account: attr_for_create)
        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET #edit' do
    before(:each) do
      log_in_as(user)
      stub_before_actions
      allow(Users::Account).to receive(:find).and_return(account)
    end

    it 'returns http success' do
      get :edit
      expect(response).to have_http_status(:success)
    end
    it 'value of @user is NOT nil' do
      expect(controller.user).not_to be_nil
      get :edit
    end
    it 'value of @account is NOT nil' do
      expect(controller.account).not_to be_nil
      get :edit
    end
  end

  describe 'PUT #update' do
    let(:attr_for_update) do
      { users_account: { email: 'bar@example.com' } }
    end

    context 'with valid params' do
      before(:each) do
        log_in_as(user)
        allow(account).to receive(:update).and_return(true)
        stub_before_actions
      end

      it 'updates the requested user' do
        expect(account).to receive(:update).with(email: 'bar@example.com')
        put(:update, attr_for_update)
      end

      it 'redirects to the user' do
        put(:update, attr_for_update)
        expect(response).to redirect_to(user_url)
      end
    end

    context 'with invalid params' do
      before(:each) do
        log_in_as(user)
        allow(account).to receive(:update).and_return(false)
        stub_before_actions
      end

      it 're-renders the "edit" template' do
        put(:update, attr_for_update)
        expect(response).to render_template('edit')
      end
    end
  end

  describe '#load_user' do
    before(:each) do
      allow(user).to receive(:id).and_return(1)
      allow(controller).to receive(:current_user).and_return(user)
      allow(User).to receive(:find).and_return(user)
    end

    describe 'expected method calls' do
      after(:each) do
        controller.send(:load_user)
      end
      it 'calls #current_user' do
        expect(controller).to receive(:current_user)
      end
      it 'calls #id on current_user' do
        expect(user).to receive(:id)
      end
      it 'calls .find on User model' do
        expect(User).to receive(:find).with(1)
      end
    end

    it 'sets value of @user ivar' do
      controller.send(:load_user)
      actual = controller.user
      expect(actual).to eq user
    end
  end

  describe '#user_account' do
    context 'when identifiable association is NOT a Users::Account object' do
      before(:each) do
        allow(user).to receive(:identifiable_account?).and_return(false)
        allow(controller).to receive(:user).and_return(user)
      end

      it 'calls #identifiable_account? on user' do
        expect(user).to receive(:identifiable_account?)
        controller.send(:user_account)
      end
      it 'does NOT call #identifiable on user' do
        expect(user).not_to receive(:identifiable)
        controller.send(:user_account)
      end
      it 'does NOT set @account ivar' do
        controller.send(:user_account)
        expect(controller.account).to be_nil
      end
    end

    context 'when identifiable association is a Users::Account object' do
      before(:each) do
        allow(user).to receive(:identifiable_account?).and_return(true)
        allow(user).to receive(:identifiable).and_return('identifiable')
        allow(controller).to receive(:user).and_return(user)
      end

      it 'calls #identifiable_account? on user' do
        expect(user).to receive(:identifiable_account?)
        controller.send(:user_account)
      end
      it 'calls #identifiable on user' do
        expect(user).to receive(:identifiable)
        controller.send(:user_account)
      end
      it 'sets @account ivar' do
        controller.send(:user_account)
        expect(controller.account).to eq 'identifiable'
      end
    end
  end

  describe '#new_user_identity_account' do
    let(:account_params) do
      { foo: 'bar' }
    end

    before(:each) do
      allow(User).to receive(:new).and_return(user)
      allow(Users::Identity).to receive(:new).and_return(identity)
      allow(Users::Account).to receive(:new).and_return(account)
      allow(controller).to receive(:account_params).and_return(account_params)
    end
    after(:each) do
      controller.send(:new_user_identity_account)
    end

    it 'sets value for @user' do
      expect(User).to receive(:new)
    end
    it 'sets value for @identity' do
      expect(Users::Identity).to receive(:new)
    end
    it 'sets value for @account' do
      expect(Users::Account).to receive(:new).with(account_params)
    end
    it 'calls #account_params' do
      expect(controller).to receive(:account_params)
    end
  end

  describe '#assign_and_save_user_identities' do
    before(:each) do
      allow(controller).to receive(:account).and_return(account)
      allow(controller).to receive(:identity).and_return(identity)
      allow(controller).to receive(:user).and_return(user)
      allow(Users::Account).to receive(:assign_and_save_user_identities!)
    end
    after(:each) do
      controller.send(:assign_and_save_user_identities!)
    end

    it 'calls #account' do
      expect(controller).to receive(:account)
    end
    it 'calls #identity' do
      expect(controller).to receive(:identity)
    end
    it 'calls #user' do
      expect(controller).to receive(:user)
    end
    it 'calls assign_and_save_user_identities! on Users::Account' do
      expect(Users::Account)
        .to receive(:assign_and_save_user_identities!)
        .with(account, identity, user)
    end
  end

  private

  def stub_before_actions
    allow(controller).to receive(:load_user)
    allow(controller).to receive(:user_account)
    allow(controller).to receive(:user).and_return(:user)
    allow(controller).to receive(:account).and_return(account)
  end
end
