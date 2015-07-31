class CoverLetter < ActiveRecord::Base
  belongs_to :job_application
  has_one :contact, :through => :interactions

  def title
    data = {
      company_name: self.job_application.company.name,
      contact: self.contact
    }
    data.values.split(' - ').join('')
  end
end
