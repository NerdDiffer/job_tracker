class Note < ActiveRecord::Base
  include Queryable

  attr_accessor :notable_name

  belongs_to :user, inverse_of: :notes
  belongs_to :notable, polymorphic: true

  validates :user, presence: true
  validates :notable, presence: true

  # scopes
  scope :sorted, -> { order(updated_at: :desc) }

  # instance methods
  def notable_name
    type = notable_type.to_s
    if type == 'Contact'
      notable.name
    elsif type == 'JobApplication'
      notable.title
    end
  end
end
