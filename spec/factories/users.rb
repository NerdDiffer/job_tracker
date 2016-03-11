FactoryGirl.define do
  factory :user do
  end

  factory :identity, class: Users::Identity do
  end

  factory :account, class: Users::Account do
    name 'Foo Bar'
    email 'foobar@example.com'
    password 'password'
  end

  factory :provider_identity, class: Users::ProviderIdentity do
    provider 'developer'
    uid '12345'
  end
end
