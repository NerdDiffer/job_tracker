class CoverLetter < ActiveRecord::Base
  belongs_to :job_application
  has_one :contact, :through => :interactions
end
