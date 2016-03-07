class Source < ActiveRecord::Base
  has_many :postings, inverse_of: :source

  validates :name, uniqueness: true

  before_save :underscore_name

  def display_name
    name.camelize
  end

  private

  def underscore_name
    self.name = name.underscore
  end
end
