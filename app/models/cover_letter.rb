class CoverLetter < ActiveRecord::Base
  include Filterable

  belongs_to :job_application
  has_one :contact, :through => :interactions

  # scopes
  scope :sorted, lambda { order(:sent_date => :desc) }

  def job_application_title
    self.job_application.title if self.job_application
  end
end
