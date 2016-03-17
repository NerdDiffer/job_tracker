module Users
  class Account < ::User
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    before_validation :downcase_email

    validates :provider, absence: true
    validates :uid, absence: true
    validates :email,
              presence: true,
              length: { maximum: 255 },
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false }
    validates :password, allow_nil: true, length: { minimum: 6 }

    has_secure_password(validations: true)

    private

    def downcase_email
      self.email = email.downcase if email.present?
    end
  end
end
