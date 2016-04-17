class Contact < ActiveRecord::Base
  extend FriendlyId
  include Queryable

  attr_writer :company_name

  friendly_id :name

  belongs_to :user
  belongs_to :company
  has_many :notes, as: :notable, dependent: :destroy

  validates :user, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :permalink, uniqueness: {
    scope: :user_id, message: "Check you don't already have a contact with the same first & last name (case-insensitive)"
  }

  scope :belonging_to_user, -> (user_id) { where(user_id: user_id) }
  scope :sorted, -> { order(first_name: :asc) }

  def self.find_by_company_name(name_of_company)
    company_name_matches = {
      companies: {
        name: name_of_company
      }
    }
    joins(:company).where(company_name_matches)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def permalink
    self.permalink = name.parameterize
  end

  def company_name
    company.name if company_id?
  end
end
