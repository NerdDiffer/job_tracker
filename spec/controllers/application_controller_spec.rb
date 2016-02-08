require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  # an anonymous controller
  controller { include SessionsHelper }

  describe '#current_user' do
    context 'when session has a user_id' do
      before(:each) do
        allow(@controller).to receive(:session).and_return(user_id: 1)
        allow(@controller).to receive(:find_user_with_session).and_return(:foo)
      end

      it 'calls find_user_with_session' do
        expect(@controller).to receive(:find_user_with_session)
        @controller.current_user
      end

      it 'sets @current_user variable' do
        @controller.current_user
        expect(assigns(:current_user)).to eq :foo
      end
    end

    context 'when cookie is signed' do
      before(:each) do
        cookies.signed[:user_id] = 1
      end

      context 'when user is found' do
        before(:each) do
          allow(@controller)
            .to receive(:find_user_with_signed_cookie)
            .and_return(User.new)
        end

        context 'when user is NOT authenticated' do
          before(:each) do
            allow(@controller).to receive(:authenticated_user?).and_return(false)
          end

          it 'does not call log_in' do
            expect(@controller).not_to receive(:log_in)
            @controller.current_user
          end
          it 'does not set @current_user' do
            @controller.current_user
            actual = @controller.instance_eval { @current_user }
            expect(actual).to be_nil
          end
        end

        context 'when user is authenticated' do
          before(:each) do
            allow(@controller).to receive(:authenticated_user?).and_return(true)
          end

          it 'calls logs_in' do
            expect(@controller).to receive(:log_in)
            @controller.current_user
          end
          it 'sets @current_user' do
            @controller.current_user
            actual = @controller.instance_eval { @current_user }
            expect(actual).not_to eq be_nil
          end
        end
      end

      context 'when user is NOT found' do
        before(:each) do
          allow(@controller)
            .to receive(:find_user_with_signed_cookie)
            .and_return(false)
        end

        it 'calls find_user_with_signed_cookie' do
          expect(@controller).to receive(:find_user_with_signed_cookie)
          @controller.current_user
        end
        it 'does not call authenticated_user?' do
          expect(@controller).not_to receive(:authenticated_user?)
          @controller.current_user
        end
      end
    end
  end
end
