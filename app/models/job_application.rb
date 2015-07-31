class JobApplication < ActiveRecord::Base
  belongs_to :company
  has_one :posting
  has_one :cover_letter

  def title
    title = ''

    self.company.present? ?
      title += self.company.name :
      title += Time.now.strftime("%Y%m%d%H%M%S")

    title += " - #{posting.job_title}" if posting.present?

    title
  end
end
