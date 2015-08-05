class Interaction < ActiveRecord::Base
  include Filterable

  belongs_to :contact

  # enum
  # in case you want to call the class method, this is pluralized as 'media'
  # `Interaction.media`
  enum medium: [ :in_person, :phone, :email, :other ]

  # scopes
  scope :sorted, lambda { order(:approx_date => :desc) }

  # instance methods
  def contact_name
    self.contact.name if self.contact
  end
end
