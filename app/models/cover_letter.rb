class CoverLetter < ActiveRecord::Base
  include Queryable

  belongs_to :job_application, inverse_of: :cover_letter

  # scopes
  scope :sorted, -> { order(sent_date: :desc) }

  def job_application_title
    job_application.title if job_application
  end
end
