class JobApplication < ActiveRecord::Base

  belongs_to :company
  belongs_to :applicant,
    :class_name => 'User',
    :foreign_key => 'user_id'
  has_one :posting
  has_one :cover_letter

  # scopes
  scope :sorted, lambda { order(:updated_at => :desc) }

  # class methods

  # @param show_active [Boolean], show active or inactive records
  # @return list of job applications
  def self.active(show_active = true)
    where(:active => show_active)
  end

  # instance methods
  def title
    title = ''

    self.company.present? ?
      title += self.company.name :
      title += Time.now.strftime("%Y%m%d%H%M%S")

    title += " - #{posting.job_title}" if posting.present?

    title
  end
end
