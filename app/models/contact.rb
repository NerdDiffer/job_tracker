class Contact < ActiveRecord::Base
  belongs_to :company
  has_many :interactions
  has_many :cover_letters, :through => :interactions

  # instance methods
  def name
    "#{self.first_name} #{self.last_name}"
  end
end
