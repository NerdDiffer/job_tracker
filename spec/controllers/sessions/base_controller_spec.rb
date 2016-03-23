require 'rails_helper'

describe Sessions::BaseController, type: :controller do
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
      expect(flash[:info]).not_to be_nil
    end
    it 'redirects to root_url' do
      delete(:destroy)
      expect(response).to redirect_to root_url
    end
  end
end
