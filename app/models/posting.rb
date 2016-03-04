class Posting < ActiveRecord::Base
  include Queryable
  include BelongsToJobApplication

  belongs_to :job_application, inverse_of: :cover_letter

  validates :job_application, presence: true

  # scopes
  scope :belonging_to_user, -> (user_id) { User.find(user_id).postings }
  scope :sorted, -> { order(posting_date: :desc, job_title: :asc) }
end
