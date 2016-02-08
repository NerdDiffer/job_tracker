class Interaction < ActiveRecord::Base
  include Filterable

  belongs_to :contact

  # Enum, pluralized as 'media' `Interaction.media`
  enum medium: [:in_person, :phone, :email, :other]

  # scopes
  scope :sorted, -> { order(approx_date: :desc) }

  # instance methods
  def contact_name
    contact.name if contact
  end
end
