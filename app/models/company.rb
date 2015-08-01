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

  def permalink
    self.permalink = self.name.parameterize
  end
end
