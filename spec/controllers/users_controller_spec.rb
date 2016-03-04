require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { build(:user, id: 1) }

  before(:each) { log_in_as(user) }

  describe 'GET #show' do
    it 'assigns the requested user as @user' do
      allow(User).to receive(:find).and_return(user)
      get(:show, id: user.id)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET #new' do
    it 'assigns a new user as @user' do
      get(:new)
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested user as @user' do
      allow(User).to receive(:find).and_return(user)
      get(:edit, id: user.id)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    let(:attr_for_create) do
      {
        first_name: 'foo', last_name: 'bar',
        email: 'foo@example.com', password: 'foobar'
      }
    end

    before(:each) do
      allow(User).to receive(:new).and_return(user)
    end

    context 'with valid params' do
      before(:each) do
        allow(user).to receive(:save).and_return(true)
      end

      it 'sets @user to a new User' do
        post(:create, user: attr_for_create)
        expect(assigns(:user)).to be_a(User)
      end

      it 'calls log_in' do
        expect(@controller).to receive(:log_in)
        post(:create, user: attr_for_create)
      end

      it 'redirects to the created user' do
        post(:create, user: attr_for_create)
        expect(response).to redirect_to(user)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(user).to receive(:save).and_return(false)
        post(:create, user: attr_for_create)
      end

      it 're-renders the "new" template' do
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    let(:attr_for_update) do
      { id: user.id, user: { email: 'bar@example.com' } }
    end

    before(:each) do
      allow(User).to receive(:find).and_return(user)
    end

    context 'with valid params' do
      before(:each) do
        allow(user).to receive(:update).and_return(true)
      end

      it 'updates the requested user' do
        expect(user).to receive(:update)
        put(:update, attr_for_update)
      end

      it 'assigns the requested user as @user' do
        put(:update, attr_for_update)
        expect(assigns(:user)).to eq(user)
      end

      it 'redirects to the user' do
        put(:update, attr_for_update)
        expect(response).to redirect_to(user)
      end
    end

    context 'with invalid params' do
      before(:each) do
        allow(user).to receive(:update).and_return(false)
        put(:update, attr_for_update)
      end

      it 'assigns the user as @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 're-renders the "edit" template' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      allow(User).to receive(:find).and_return(user)
    end

    it 'calls destroy on user' do
      expect(user).to receive(:destroy)
      delete(:destroy, id: 'foo')
    end
    it 'redirects to the users list' do
      delete(:destroy, id: 'foo')
      expect(response).to redirect_to(users_url)
    end
  end

  describe '#check_user' do
    after(:each) do
      controller.send(:check_user)
    end

    it 'calls #current_user?' do
      allow(controller).to receive(:current_user?).and_return(true)
      expect(controller).to receive(:current_user?).with(assigns(:user))
    end
    context 'when #correct_user? is true' do
      it 'does not redirect' do
        allow(controller).to receive(:current_user?).and_return(true)
        expect(controller).not_to receive(:redirect_to)
      end
    end
    context 'when #correct_user? is false' do
      it 'redirects to root_url' do
        allow(controller).to receive(:current_user?).and_return(false)
        allow(controller).to receive(:redirect_to).and_return(true)
        expect(controller).to receive(:redirect_to).with(root_url)
      end
    end
  end
end
