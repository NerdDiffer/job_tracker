FactoryGirl.define do
  factory :user do
  end

  factory :account, class: Users::Account do
    type 'Users::Account'
    name 'John Doe'
    email 'john.doe@example.com'
    password 'password'
  end

  factory :omni_auth_user, class: Users::OmniAuthUser do
    type 'Users::OmniAuthUser'
    name 'Jane Doe'
    provider 'developer'
    uid '12345'
  end
end
