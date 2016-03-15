module Users
  # A user who uses OAuth to authenticate their account
  class ProviderIdentity < ActiveRecord::Base
    has_one :identity, as: :identifiable

    validates_presence_of [:uid, :provider, :identity]
    validates :uid, uniqueness: { scope: :provider }
    validates_associated :identity

    before_save :downcase_provider

    class << self
      def find_from_omni_auth(auth)
        params = extract_params(auth)
        where(params).first
      end

      def create_from_omni_auth(auth)
        params = extract_params(auth)
        identity = Users::Identity.new
        user = User.new
        provider_id = new(params)

        assign_user_identities(provider_id, identity, user)

        provider_id if save_user_identities!(provider_id, identity, user)
      end

      private

      def extract_params(auth)
        { provider: auth['provider'], uid: auth['uid'] }
      end

      def assign_user_identities(provider_id, identity, user)
        provider_id.identity = identity
        identity.identifiable = provider_id
        identity.user = user
        user.identity = identity
      end

      def save_user_identities!(provider_id, identity, user)
        provider_id.save && identity.save && user.save
      end
    end

    def user
      identity.user
    end

    private

    def downcase_provider
      self.provider = provider.downcase
    end
  end
end
