module JobApplications
  class Posting < ActiveRecord::Base
    include Queryable
    include BelongsToJobApplication

    belongs_to :job_application, inverse_of: :posting
    belongs_to :source, inverse_of: :postings

    validates :job_application, presence: true
    validates_uniqueness_of :job_application_id

    scope :belonging_to_user, -> (user_id) { User.find(user_id).postings }
    scope :sorted, -> { order(posting_date: :desc, job_title: :asc) }
  end
end
