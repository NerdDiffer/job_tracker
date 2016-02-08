class Company < ActiveRecord::Base
  extend FriendlyId
  include Filterable

  friendly_id :name

  has_many :contacts
  has_many :job_applications

  validates :name, uniqueness: true, presence: true
  validates :permalink, uniqueness: true

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
end
