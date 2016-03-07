class Category < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name

  has_and_belongs_to_many :companies, join_table: 'companies_categories'

  validates :name, presence: true
  validates :permalink, uniqueness: true, presence: true

  after_save :refresh_search_suggestions

  def permalink
    self.permalink = name.parameterize
  end

  def display_name
    name.titleize
  end

  def company_names
    companies.map(&:name)
  end

  private

  def refresh_search_suggestions
    SearchSuggestion.refresh_category_names
  end
end
