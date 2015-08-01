class Contact < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  belongs_to :company
  has_many :interactions
  has_many :cover_letters, :through => :interactions

  validates :first_name,
    presence: true
  validates :last_name,
    presence: true
  validates :permalink,
    uniqueness: true

  # scopes
  scope :sorted, lambda { order(:first_name => :asc) }

  # instance methods
  def name
    "#{self.first_name} #{self.last_name}"
  end
  def permalink
    self.permalink = name.parameterize
  end
end
