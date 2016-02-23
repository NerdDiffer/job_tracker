class Contact < ActiveRecord::Base
  extend FriendlyId
  include Queryable

  attr_accessor :company_name

  friendly_id :name

  belongs_to :user
  belongs_to :company
  has_many :interactions
  has_many :cover_letters, through: :interactions

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :permalink, uniqueness: true

  after_save :refresh_search_suggestions

  # scopes
  scope :sorted, -> { order(first_name: :asc) }

  # class methods
  def self.find_by_name(name)
    name_as_arr = name.split(' ')
    first_name = name_as_arr.first
    # just in case the last name is more than 1 word long...
    last_name = name_as_arr[1...name_as_arr.length].join(' ')
    find_by_first_name_and_last_name(first_name, last_name)
  end

  def self.find_by_company_name(name_of_company)
    company_name_matches = {
      companies: {
        name: name_of_company
      }
    }
    joins(:company).where(company_name_matches)
  end

  # instance methods
  def name
    "#{first_name} #{last_name}"
  end

  def permalink
    self.permalink = name.parameterize
  end

  def company_name
    company.name if company
  end

  private

  def refresh_search_suggestions
    SearchSuggestion.refresh_contact_names
  end
end
