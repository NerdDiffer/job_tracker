class Company < ActiveRecord::Base
  extend FriendlyId
  include Queryable
  include SearchSuggestion::Refresh::Model

  AGENCY_CATEGORY = 'Recruiting Agency'.freeze

  attr_reader :agency

  friendly_id :name

  has_many :contacts
  has_many :job_applications
  has_and_belongs_to_many :categories, join_table: 'companies_categories'

  has_many :recruitments_as_agency,
           foreign_key: 'agency_id',
           class_name: 'Recruitment',
           inverse_of: :agency
  has_many :clients, through: :recruitments_as_agency

  has_many :recruitments_as_client,
           foreign_key: 'client_id',
           class_name: 'Recruitment',
           inverse_of: :client
  has_many :agencies, through: :recruitments_as_client

  validates :name, uniqueness: true, presence: true
  validates :permalink, uniqueness: true
  validate  :name_allowed?

  before_destroy :delete_redis_keys
  after_save :refresh_search_suggestions

  scope :sorted, -> { order(:name) }
  scope :by_name, -> (q) { where('companies.name ILIKE ?', "%#{q}%") }

  def self.search(search)
    search ? by_name(search) : unscoped
  end

  def self.by_category_name(names_of_categories)
    names_of_categories = names_of_categories.map { |n| "'#{n}'" }
    names_of_categories = names_of_categories.join(', ')

    includes(:categories)
      .where("categories.name IN (#{names_of_categories})")
  end

  def self.search_and_filter(name_query, names_of_categories)
    result = Company.joins(:companies_categories, :categories)
    result = result.by_name(name_query) unless name_query.empty?
    result = result.by_category_name(names_of_categories) unless names_of_categories.empty?
    result.distinct
  end

  def permalink
    self.permalink = name.parameterize
  end

  def category_names
    categories.map(&:display_name)
  end

  def agency?
    @agency ||= agency_category?
  end

  private

  def name_allowed?
    errors.add(:name, "'*' as last character is not allowed") if last_char_star?
  end

  def last_char_star?
    last_char = name[(-1..-1)]
    last_char == '*'
  end

  def refresh_search_suggestions
    SearchSuggestion.refresh_company_names
  end

  def names_base_key
    'company_names'
  end

  def delete_redis_keys
    delete_redis_keys!
  end

  def agency_category?
    category_names.include? AGENCY_CATEGORY
  end
end
