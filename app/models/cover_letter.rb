class CoverLetter < ActiveRecord::Base
  include Queryable
  include BelongsToJobApplication

  belongs_to :job_application, inverse_of: :cover_letter

  validates :job_application, presence: true

  # scopes
  scope :belonging_to_user, -> (user_id) { User.find(user_id).cover_letters }
  scope :sorted, -> { order(sent_date: :desc) }
end
