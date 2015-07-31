class JobApplication < ActiveRecord::Base
  belongs_to :company
  has_one :posting
  has_one :cover_letter

  def title
    t = ''
    self.company.present? ?
      t += self.company.name :
      t += Time.now.strftime("%Y%m%d%H%M%S")
    t += " - #{posting.job_title}" if posting.present?
  end
end
