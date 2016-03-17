module Sessions
  class OmniAuthUsersController < BaseController
    before_action :set_user, only: :create

    attr_reader :auth_hash

    def create
      begin
        log_in(user)
      rescue
        redirect_to(action: 'failure')
        return
      end
      flash[:success] = 'Signed in'
      redirect_to(root_url)
    end

    def failure
      flash[:danger] = 'There was an error authenticating you.'
      redirect_to(root_url)
    end

    private

    def set_user
      request_auth_hash
      @user = find || create!
    end

    def request_auth_hash
      @auth_hash = request.env['omniauth.auth']
    end

    def find
      Users::OmniAuthUser.find_from_omni_auth(auth_hash)
    end

    def create!
      Users::OmniAuthUser.create_from_omni_auth!(auth_hash)
    end
  end
end
