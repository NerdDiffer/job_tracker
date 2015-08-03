class CoverLetter < ActiveRecord::Base
  belongs_to :job_application
  has_one :contact, :through => :interactions

  # scopes
  scope :sorted, lambda { order(:sent_date => :desc) }

  def title
    data = {
      company_name: self.job_application.company.name,
      contact: self.contact
    }
    data.values.split(' - ').join('')
  end
end
