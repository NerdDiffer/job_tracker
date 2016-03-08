require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { build(:user) }

  describe 'GET #new' do
    it 'redirects to current_user if logged in' do
      allow(@controller).to receive(:current_user).and_return(user)
      allow(@controller).to receive(:logged_in?).and_return(true)
      get(:new)
      expect(response).to redirect_to(user_path)
    end
    it 'renders "new" if not logged in' do
      allow(@controller).to receive(:logged_in?).and_return(false)
      get(:new)
      expect(response).to render_template 'new'
    end
  end

  describe 'POST #create' do
    context 'if email_and_password are present' do
      before(:each) do
        allow(@controller).to receive(:email_and_password?).and_return(true)
        allow(@controller).to receive(:authenticated?).and_return(false)
      end

      it 'calls #find_user_by_email' do
        expect(@controller).to receive(:find_user_by_email)
        post(:create)
      end
    end

    context 'if authenticated?' do
      before(:each) do
        allow(@controller).to receive(:email_and_password?).and_return(true)
        allow(@controller).to receive(:find_user_by_email).and_return(user)
        allow(@controller).to receive(:authenticated?).and_return(true)
      end

      it 'calls #login_authenticted_user' do
        expect(@controller).to receive(:login_authenticated_user)
        post(:create)
      end
    end

    context 'if not authenticated' do
      before(:each) do
        allow(@controller).to receive(:email_and_password?).and_return(true)
        allow(@controller).to receive(:find_user_by_email).and_return(user)
        allow(@controller).to receive(:authenticated?).and_return(false)
        post(:create)
      end

      it 'sets a flash message' do
        expect(flash.now[:danger]).not_to be_nil
      end
      it 'renders "new"' do
        expect(response).to render_template 'new'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'if logged_in?' do
      before(:each) do
        allow(@controller).to receive(:logged_in?).and_return(true)
      end

      it 'logs out' do
        expect(@controller).to receive(:log_out)
        delete(:destroy)
      end
    end
    it 'sets flash message' do
      delete(:destroy)
      expect(flash[:notice]).not_to be_nil
    end
    it 'redirects to root_url' do
      delete(:destroy)
      expect(response).to redirect_to root_url
    end
  end

  describe '#email_and_password?' do
    it 'is true if both return true' do
      allow(@controller).to receive(:email?).and_return(true)
      allow(@controller).to receive(:password?).and_return(true)
      actual = @controller.send(:email_and_password?)
      expect(actual).to be_truthy
    end
    it 'is otherwise false' do
      allow(@controller).to receive(:email?).and_return(false)
      allow(@controller).to receive(:password?).and_return(true)
      actual = @controller.send(:email_and_password?)
      expect(actual).to be_falsey
    end
  end

  describe '#email?' do
    it 'is true if a value for email is present' do
      params = { session: { email: 'foo' } }
      allow(@controller).to receive(:params).and_return(params)
      actual = @controller.send(:email?)
      expect(actual).to be_truthy
    end
    it 'is falsey if a value for email is NOT present' do
      params = { session: { email: nil } }
      allow(@controller).to receive(:params).and_return(params)
      actual = @controller.send(:email?)
      expect(actual).to be_falsey
    end
  end

  describe '#password?' do
    it 'is true if a value for password is present' do
      params = { session: { password: 'foo' } }
      allow(@controller).to receive(:params).and_return(params)
      actual = @controller.send(:password?)
      expect(actual).to be_truthy
    end
    it 'is falsey if a value for password is NOT present' do
      params = { session: { password: nil } }
      allow(@controller).to receive(:params).and_return(params)
      actual = @controller.send(:password?)
      expect(actual).to be_falsey
    end
  end

  describe '#find_user_by_email' do
    it 'calls user.find_by with a hash' do
      params = { session: { email: 'foo' } }
      allow(@controller).to receive(:params).and_return(params)
      expect(User).to receive(:find_by).with(email: 'foo')
      @controller.send(:find_user_by_email)
    end
  end

  describe '#authenticated?' do
    params = { session: { password: 'foo' } }
    before(:each) do
      allow(@controller).to receive(:params).and_return(params)
    end

    it 'calls authenticate on the user' do
      expect(user).to receive(:authenticate)
      @controller.send(:authenticated?, user)
    end
    it 'returns false if user is falsey' do
      expect(user).not_to receive(:authenticate)
      actual = @controller.send(:authenticated?, nil)
      expect(actual).to be_falsey
    end
    it 'returns false if authentication was NOT successful' do
      allow(user).to receive(:authenticate).and_return(false)
      actual = @controller.send(:authenticated?, user)
      expect(actual).to be_falsey
    end
    it 'returns true if authentication was successful' do
      expect(user).to receive(:authenticate)
      @controller.send(:authenticated?, user)
    end
  end

  describe '#login_authenticated_user' do
    shared_examples_for 'logging in an authenticated_user' do
      before(:each) do
        allow(@controller).to receive(:log_in).and_return(true)
        allow(@controller).to receive(:redirect_back_or).and_return(true)
      end

      it 'calls log_in with user' do
        expect(@controller).to receive(:log_in).with(user)
        @controller.send(:login_authenticated_user, user)
      end
      it 'sets flash message' do
        @controller.send(:login_authenticated_user, user)
        expect(flash[:success]).not_to be_nil
      end
      it 'calls #redirect_back_or with user' do
        expect(@controller).to receive(:redirect_back_or).with(user_path)
        @controller.send(:login_authenticated_user, user)
      end
    end

    context 'when remember_me is set' do
      it_behaves_like 'logging in an authenticated_user' do
        before(:each) do
          allow(@controller).to receive(:remember_me?).and_return(true)
          allow(@controller).to receive(:remember).and_return(true)
        end

        it 'calls remember with user' do
          expect(@controller).to receive(:remember).with(user)
          @controller.send(:login_authenticated_user, user)
        end
      end
    end

    context 'when remember_me is NOT set' do
      it_behaves_like 'logging in an authenticated_user' do
        before(:each) do
          allow(@controller).to receive(:remember_me?).and_return(false)
          allow(@controller).to receive(:forget).and_return(true)
        end

        it 'calls forget with user' do
          expect(@controller).to receive(:forget).with(user)
          @controller.send(:login_authenticated_user, user)
        end
      end
    end
  end

  describe '#remember_me?' do
    it 'returns true if params[:session][:remember_me] is 1' do
      params = { session: { remember_me: '1' } }
      allow(@controller).to receive(:params).and_return(params)
      expect(@controller.send(:remember_me?)).to be_truthy
    end
    it 'otherwise returns false' do
      params = { session: { remember_me: '0' } }
      allow(@controller).to receive(:params).and_return(params)
      expect(@controller.send(:remember_me?)).to be_falsey
    end
  end
end
