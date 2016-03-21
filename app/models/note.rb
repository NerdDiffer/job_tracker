class Note < ActiveRecord::Base
  include Queryable

  attr_writer :notable_name

  belongs_to :user
  belongs_to :notable, polymorphic: true

  validates :user, presence: true
  validates :notable, presence: true

  # scopes
  scope :belonging_to_user, -> (user_id) { where(user_id: user_id) }
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
