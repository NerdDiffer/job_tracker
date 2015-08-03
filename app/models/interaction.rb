class Interaction < ActiveRecord::Base
  belongs_to :contact

  # enum
  # in case you want to call the class method, this is pluralized as 'media'
  # `Interaction.media`
  enum medium: [ :in_person, :phone, :email, :other ]

  # scopes
  scope :sorted, lambda { order(:approx_date => :desc) }

end
