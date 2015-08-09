FactoryGirl.define do
  factory :contact do
    first_name 'Joe'
    last_name 'Schmoe'
    title 'Fancy Job Title'
    phone_office '123.456.7890'
    phone_mobile '123.890.4567'
    email 'contact@example.com'
  end
end
