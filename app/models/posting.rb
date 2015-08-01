class Posting < ActiveRecord::Base
  belongs_to :job_application

  # scopes
  scope :sorted, lambda { order(:posting_date => :desc, :job_title => :asc) }
end
