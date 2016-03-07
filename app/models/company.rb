class Company < ActiveRecord::Base
  extend FriendlyId
  include Queryable
  include SearchSuggestion::Refresh::Model

  friendly_id :name

  has_many :contacts
  has_many :job_applications
  has_and_belongs_to_many :categories, join_table: 'companies_categories'

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

  def self.by_category_name(category_names)
    category_names = category_names.map { |n| "'#{n}'" }
    category_names = category_names.join(', ')

    includes(:categories)
      .where("categories.name IN (#{category_names})")
  end

  def self.search_and_filter(name_query, category_names)
    result = Company.joins(:companies_categories, :categories)

    unless name_query.empty?
      result = result.by_name(name_query)
    end
    unless category_names.empty?
      result = result.by_category_name(category_names)
    end

    result.distinct
  end

  def permalink
    self.permalink = name.parameterize
  end

  def category_names
    categories.map(&:display_name)
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
end
