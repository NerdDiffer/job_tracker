class Contact < ActiveRecord::Base
  belongs_to :company
  has_many :interactions
  has_many :cover_letters, :through => :interactions
end
