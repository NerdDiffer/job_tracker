class User < ActiveRecord::Base
  include Users::AuthenticatedSessions

  attr_accessor :remember_token

  has_secure_password(validations: false)

  has_many :contacts, dependent: :destroy
  has_many :notes, inverse_of: :user, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_many :companies, through: :job_applications
  has_many :cover_letters, through: :job_applications
  has_many :postings, through: :job_applications

  validates :type, presence: true

  def account?
    type == account
  end

  private

  def account
    'Users::Account'
  end

  def add_type_error
    errors.add(:type, "Type must NOT be #{account}")
  end
end
