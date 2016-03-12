class Sessions::ProviderIdentitiesController < Sessions::BaseController
  before_action :set_provider_id, only: :create
  before_action :set_user,        only: :create

  attr_reader :provider_id

  def create
    begin
      log_in(user)
    rescue
      redirect_to(action: 'failure')
      return
    end
    redirect_to(root_url, notice: 'Signed in')
  end

  def failure
    danger = { danger: 'There was an error authenticating you.' }
    redirect_to(root_url, flash: danger)
  end

  private

  def set_provider_id
    @provider_id = find_provider_identity || create_provider_identity
  end

  def set_user
    @user = provider_id.user rescue nil
  end

  def user_info_from_omni_auth
    request.env['omniauth.auth']
  end

  def find_provider_identity
    Users::ProviderIdentity.find_from_omni_auth(user_info_from_omni_auth)
  end

  def create_provider_identity
    Users::ProviderIdentity.create_from_omni_auth(user_info_from_omni_auth)
  end
end
