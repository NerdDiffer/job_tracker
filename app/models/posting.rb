class Posting < ActiveRecord::Base
  include Queryable

  belongs_to :job_application, inverse_of: :cover_letter

  # scopes
  scope :sorted, -> { order(posting_date: :desc, job_title: :asc) }

  def job_application_title
    job_application.title if job_application
  end
end
