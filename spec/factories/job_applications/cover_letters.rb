FactoryGirl.define do
  factory :cover_letter, class: JobApplications::CoverLetter do
    content 'Lorem ipsum'
    sent_date Date.new(2015, 8, 1)
  end
end
