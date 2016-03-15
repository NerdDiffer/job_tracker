class User < ActiveRecord::Base
  has_one  :identity, inverse_of: :user, class_name: 'Users::Identity'
  has_many :contacts, dependent: :destroy
  has_many :notes, inverse_of: :user, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_many :companies, through: :job_applications
  has_many :cover_letters, through: :job_applications
  has_many :postings, through: :job_applications

  validates :identity, presence: true

  def identifiable
    identity.identifiable
  end

  def identifiable_account?
    identifiable.class.to_s == account_class_name
  end

  def identifiable_provider_identity?
    identifiable.class.to_s == provider_identity_class_name
  end

  def remember
    identifiable.remember if identifiable_account?
  end

  def forget
    identifiable.forget if identifiable_account?
  end

  def remember_token
    identifiable.remember_token if identifiable_account?
  end

  def authenticate(unencrypted_password)
    identifiable.authenticate(unencrypted_password) if identifiable_account?
  end

  def authenticated?(attr, token)
    identifiable.authenticated?(attr, token) if identifiable_account?
  end

  private

  def account_class_name
    'Users::Account'
  end

  def provider_identity_class_name
    'Users::ProviderIdentity'
  end
end
