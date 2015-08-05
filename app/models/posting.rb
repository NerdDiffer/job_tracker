class Posting < ActiveRecord::Base
  include Filterable

  belongs_to :job_application

  # scopes
  scope :sorted, lambda { order(:posting_date => :desc, :job_title => :asc) }

  def job_application_title
    self.job_application.title if self.job_application
  end
end
