class User < ActiveRecord::Base
  include Users::AuthenticatedSessions

  attr_accessor :remember_token

  has_many :contacts, dependent: :destroy
  has_many :notes, inverse_of: :user, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_many :companies, through: :job_applications
  has_many :cover_letters, through: :job_applications
  has_many :postings, through: :job_applications

  validates :type, presence: true

  has_secure_password(validations: false)

  def account?
    type == account
  end

  private

  def account
    'Users::Account'
  end
end
