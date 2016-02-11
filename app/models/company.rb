class Company < ActiveRecord::Base
  extend FriendlyId
  include Queryable

  friendly_id :name

  has_many :contacts
  has_many :job_applications

  validates :name, uniqueness: true, presence: true
  validates :permalink, uniqueness: true

  after_save :refresh_search_suggestions

  # scopes
  scope :sorted, -> { order(:name) }
  scope :by_name, -> (q) { where('name ILIKE ?', "%#{q}%") }

  # other class methods
  def self.search(search)
    search ? by_name(search) : unscoped
  end

  # instance methods
  def permalink
    self.permalink = name.parameterize
  end

  private

  def refresh_search_suggestions
    SearchSuggestion.refresh_company_names
  end
end
