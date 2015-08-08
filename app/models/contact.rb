class Contact < ActiveRecord::Base
  extend FriendlyId
  include Filterable

  attr_accessor :company_name

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

  # class methods
  def self.find_by_name(name)
    name_as_arr = name.split(' ')
    first_name = name_as_arr.first
    # just in case the last name is more than 1 word long...
    last_name = name_as_arr[1...name_as_arr.length].join(' ')
    where(first_name: first_name, last_name: last_name)
  end

  # instance methods
  def name
    "#{self.first_name} #{self.last_name}"
  end
  def permalink
    self.permalink = name.parameterize
  end
  def company_name
    self.company.name if self.company
  end
end
