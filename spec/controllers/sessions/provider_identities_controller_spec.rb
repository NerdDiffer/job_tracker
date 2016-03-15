require 'rails_helper'

describe Sessions::ProviderIdentitiesController, type: :controller do
  let(:user) { build(:user) }
  let(:provider_id) { build(:provider_identity) }

  describe '#POST create' do
    before(:each) do
      allow(@controller).to receive(:set_provider_id)
      allow(@controller).to receive(:set_user)
      allow(@controller).to receive(:user).and_return(user)
      allow(@controller).to receive(:render).and_return(true)
    end

    context 'success' do
      before(:each) do
        allow(@controller).to receive(:log_in).and_return(true)
        post(:create, provider: 'foo')
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_url
      end
      it 'has a flash message' do
        expect(flash[:notice]).not_to be_nil
      end
    end

    context 'failed authentication' do
      before(:each) do
        allow(@controller).to receive(:log_in).and_raise('error')
      end

      it 'redirects to failure action' do
        post(:create, provider: 'foo')
        expect(response).to redirect_to(action: 'failure')
      end
      it 'returns early & does not redirect user to root url' do
        expect(@controller).not_to receive(:redirect_to).with(root_url)
        post(:create, provider: 'foo')
      end
    end
  end

  describe '#GET failure' do
    it 'redirects to root' do
      get(:failure)
      expect(response).to redirect_to(root_url)
    end
    it 'has a flash message on danger key' do
      get(:failure)
      expect(flash[:danger]).not_to be_nil
    end
  end

  describe '#set_provider_id' do
    context 'if #find_provider_identity is truthy' do
      before(:each) do
        allow(@controller).to receive(:find_provider_identity).and_return(true)
        allow(@controller).to receive(:create_provider_identity)
      end

      it 'calls #find_provider_identity' do
        expect(@controller).to receive(:find_provider_identity)
        @controller.send(:set_provider_id)
      end
      it 'does NOT call #create_provider_identity' do
        expect(@controller).not_to receive(:create_provider_identity)
        @controller.send(:set_provider_id)
      end
      it 'sets a value for @provider_id' do
        @controller.send(:set_provider_id)
        actual = @controller.provider_id
        expect(actual).not_to be_nil
      end
    end

    context 'if #find_provider_identity is falsey' do
      before(:each) do
        allow(@controller).to receive(:find_provider_identity).and_return(nil)
        allow(@controller).to receive(:create_provider_identity).and_return(:foo)
      end

      it 'calls #find_provider_identity' do
        expect(@controller).to receive(:find_provider_identity)
        @controller.send(:set_provider_id)
      end
      it 'calls #create_provider_identity' do
        expect(@controller).to receive(:create_provider_identity)
        @controller.send(:set_provider_id)
      end
      it 'sets a value for @provider_id' do
        @controller.send(:set_provider_id)
        actual = @controller.provider_id
        expect(actual).not_to be_nil
      end
    end

    context 'if calls to both methods return falsey values' do
      before(:each) do
        allow(@controller).to receive(:find_provider_identity).and_return(nil)
        allow(@controller).to receive(:create_provider_identity).and_return(nil)
      end

      it 'calls #find_provider_identity' do
        expect(@controller).to receive(:find_provider_identity)
        @controller.send(:set_provider_id)
      end
      it 'calls #create_provider_identity' do
        expect(@controller).to receive(:create_provider_identity)
        @controller.send(:set_provider_id)
      end
      it '@provider_id is nil' do
        @controller.send(:set_provider_id)
        actual = @controller.provider_id
        expect(actual).to be_nil
      end
    end
  end

  describe '#set_user' do
    context 'when provider_id is NOT nil' do
      before(:each) do
        allow(@controller).to receive(:provider_id).and_return(provider_id)
        allow(provider_id).to receive(:user).and_return(user)
      end

      it 'calls #user on provider_id' do
        expect(provider_id).to receive(:user)
        @controller.send(:set_user)
      end
      it 'sets a value for @user' do
        @controller.send(:set_user)
        expect(@controller.user).not_to be_nil
      end
    end

    context 'when provider_id is nil' do
      before(:each) do
        allow(@controller).to receive(:provider_id).and_return(nil)
      end

      it 'sets @user to nil' do
        expect(@controller.user).to be_nil
        @controller.send(:set_user)
      end
    end
  end

  describe '#user_info_from_omni_auth' do
    let(:env) do
      { 'omniauth.auth' => 'foobar' }
    end
    let(:request) do
      double('request', env: env)
    end

    before(:each) do
      allow(@controller).to receive(:request).and_return(request)
    end

    it 'calls #request' do
      expect(@controller).to receive(:request)
      @controller.send(:user_info_from_omni_auth)
    end
    it 'calls #env on request' do
      expect(request).to receive(:env)
      @controller.send(:user_info_from_omni_auth)
    end
    it 'returns value of the "omni_auth.auth" key' do
      actual = @controller.send(:user_info_from_omni_auth)
      expect(actual).to eq 'foobar'
    end
  end

  describe '#find_provider_identity' do
    before(:each) do
      allow(@controller).to receive(:user_info_from_omni_auth).and_return(:foo)
      allow(Users::ProviderIdentity).to receive(:find_from_omni_auth)
    end
    after(:each) do
      @controller.send(:find_provider_identity)
    end

    it 'calls #user_info_from_omni_auth' do
      expect(@controller).to receive(:user_info_from_omni_auth)
    end
    it 'calls .find_from_omni_auth on Users::ProviderIdentity' do
      expect(Users::ProviderIdentity).to receive(:find_from_omni_auth).with(:foo)
    end
  end

  describe '#create_provider_identity' do
    before(:each) do
      allow(@controller).to receive(:user_info_from_omni_auth).and_return(:foo)
      allow(Users::ProviderIdentity).to receive(:create_from_omni_auth)
    end
    after(:each) do
      @controller.send(:create_provider_identity)
    end

    it 'calls #user_info_from_omni_auth' do
      expect(@controller).to receive(:user_info_from_omni_auth)
    end
    it 'calls .find_from_omni_auth on Users::ProviderIdentity' do
      expect(Users::ProviderIdentity)
        .to receive(:create_from_omni_auth)
        .with(:foo)
    end
  end
end
