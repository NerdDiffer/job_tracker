module Users
  # A user who chooses NOT to authenticate with OAuth
  class Account < ActiveRecord::Base
    include AuthenticatedSessions

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    attr_accessor :remember_token

    has_secure_password

    has_one :identity, as: :identifiable

    validates :identity, presence: true
    validates :email,
              length: { maximum: 255 },
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false }
    validates :password, allow_nil: true, length: { minimum: 6 }
    validates_associated :identity

    before_save :downcase_email

    class << self
      def assign_and_save_user_identities!(account, identity, user)
        assign_user_identities(account, identity, user)
        save_user_identities!(account, identity, user)
      end

      private

      def assign_user_identities(account, identity, user)
        account.identity = identity
        identity.identifiable = account
        identity.user = user
        user.identity = identity
      end

      def save_user_identities!(account, identity, user)
        account.save && identity.save && user.save
      end
    end

    def user
      identity.user
    end

    private

    def downcase_email
      self.email = email.downcase
    end
  end
end
