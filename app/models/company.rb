class Company < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  has_many :contacts
  has_many :job_applications

  validates :name,
    uniqueness: true,
    presence: true
  validates :permalink,
    uniqueness: true

  # scopes
  scope :sorted, lambda { order(:name) }
  scope :by_name, lambda { |q| where("name ILIKE ?", "%#{q}%") }

  # other class methods
  def self.search(search)
    search ? by_name(search) : unscoped
  end

  # instance methods
  def permalink
    self.permalink = self.name.parameterize
  end
end
