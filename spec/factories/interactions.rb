FactoryGirl.define do
  factory :interaction do
    notes 'Lorem ipsum'
    approx_date Date.new(2015, 8, 1)
    medium 1
  end
end
