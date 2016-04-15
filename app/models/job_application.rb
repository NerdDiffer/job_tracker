class JobApplication < ActiveRecord::Base
  include Queryable

  attr_writer :company_name

  belongs_to :company
  belongs_to :user
  has_many :notes, as: :notable, dependent: :destroy
  has_one :posting, inverse_of: :job_application, dependent: :destroy, class_name: 'JobApplications::Posting'
  has_one :cover_letter, inverse_of: :job_application, dependent: :destroy, class_name: 'JobApplications::CoverLetter'

  validates :user, presence: true

  scope :belonging_to_user, -> (user_id) { where(user_id: user_id) }
  scope :sorted, -> { order(updated_at: :desc) }

  # A named scope for selecting active or inactive job applications
  # @param show_active [Boolean], show active or inactive records
  # @return list of job applications
  def self.active(active = nil)
    if active
      where(active: active)
    else
      where(nil)
    end
  end

  def title
    title = if company_id?
              company.name
            else
              created_at.utc.strftime('%Y%m%d%H%M%S')
            end

    title += " - #{posting.job_title}" if posting.present?

    title
  end

  def company_name
    company.name if company_id?
  end
end
