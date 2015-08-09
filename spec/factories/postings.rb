FactoryGirl.define do
  factory :posting do
    content 'Lorem ipsum'
    job_title 'Chief Hot Pocket'
    posting_date Date.new(2015, 8, 1)
    source 'Indeed'
  end
end
