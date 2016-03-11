require 'faker'

module Seed
  class << self
    private

    def new_default_account
      user = default_user.merge(password: default_password,
                                password_confirmation: default_password)
      Users::Account.new(user)
    end

    def new_account
      name = Faker::Name.name
      email = Faker::Internet.safe_email(name)
      password = default_password
      password_confirmation = default_password
      Users::Account.new(name: name, email: email,
                         password: password,
                         password_confirmation: password_confirmation)
    end

    def new_provider_identity(uid)
      Users::ProviderIdentity.new(uid: uid,
                                  provider: default_provider)
    end

    def assign_and_save_users!(identifiable, identity, user)
      identifiable.identity = identity
      identity.identifiable = identifiable
      identity.user = user
      user.identity = identity

      identifiable.save! && identity.save! && user.save!
    end
  end
end
