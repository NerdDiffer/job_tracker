FactoryGirl.define do
  factory :user do
  end

  factory :account, class: Users::Account do
    first_name 'John'
    last_name 'Doe'
    email 'john.doe@example.com'
    password 'password'
    type 'Users::Account'
  end

  factory :omni_auth_user, class: Users::OmniAuthUser do
    provider 'developer'
    uid '12345'
    type 'Users::OmniAuthUser'
  end
end
