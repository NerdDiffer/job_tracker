class Company < ActiveRecord::Base
  has_many :contacts
  has_many :job_applications
end
