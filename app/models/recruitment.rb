class Recruitment < ActiveRecord::Base
  belongs_to :recruit,
    class_name: 'User',
    foreign_key: 'recruit_id'
  belongs_to :agency, class_name: 'Company'
  belongs_to :client, class_name: 'Company'

  attr_reader :category_ids

  validates :recruit, presence: true
  validates :agency, presence: true
  validates :client, presence: true, uniqueness: {
    scope: :recruit_id, message: 'already has this relationship to agency'
  }
  validate :validate_agency_category

  def client_name
    client.name if client_id?
  end

  def agency_name
    agency.name if agency_id?
  end

  private

  def validate_agency_category
    unless recruiting_agency?
      msg = "must have a category of #{Company::AGENCY_CATEGORY}"
      errors.add(:agency, msg)
    end
  end

  def recruiting_agency?
    agency.agency?
  end
end
