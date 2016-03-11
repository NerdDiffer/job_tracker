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

  describe 'DELETE #destroy' do
    before(:each) do
      allow(User).to receive(:find).and_return(user)
      allow(user).to receive(:destroy).and_return(true)
    end

    it 'calls destroy on user' do
      expect(user).to receive(:destroy)
      delete(:destroy, id: 'foo')
    end
    it 'redirects to the users list' do
      delete(:destroy, id: 'foo')
      expect(response).to redirect_to(user_url)
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
