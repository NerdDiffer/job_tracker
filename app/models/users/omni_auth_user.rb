module Users
  class OmniAuthUser < ::User
    before_validation :downcase_provider

    validate  :validate_type
    validates :provider, presence: true
    validates :uid, presence: true, uniqueness: { scope: :provider }

    has_secure_password(validations: false)

    class << self
      def find_from_omni_auth(auth)
        params = extract_params(auth)
        where(params).first
      end

      def create_from_omni_auth!(auth)
        params = extract_params(auth)
        create!(params)
      end

      private

      def extract_params(auth)
        { provider: auth['provider'], uid: auth['uid'] }
      end
    end

    private

    def downcase_provider
      self.provider = provider.downcase
    end

    def validate_type
      add_type_error if account?
    end
  end
end
