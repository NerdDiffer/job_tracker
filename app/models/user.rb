class User < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :job_applications

  has_secure_password

  # model validations
  validates :first_name,
    presence: true
  validates :last_name,
    presence: true
  validates :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { :case_sensitive => false }
  validates :password,
    allow_nil: true,
    length: { minimum: 6 }

  before_save :downcase_email

  private
    def downcase_email
      self.email = email.downcase
    end
end
