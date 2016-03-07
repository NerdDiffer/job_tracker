class Category < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name

  has_and_belongs_to_many :companies, join_table: 'companies_categories'

  validates :name, presence: true
  validates :permalink, uniqueness: true, presence: true

  def permalink
    self.permalink = name.parameterize
  end

  def display_name
    name.titleize
  end

  def company_names
    companies.map(&:name)
  end
end
