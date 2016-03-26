class Note < ActiveRecord::Base
  include Queryable

  belongs_to :user
  belongs_to :notable, polymorphic: true

  validates :user, presence: true
  validates :notable, presence: true

  scope :belonging_to_user, -> (user_id) { where(user_id: user_id) }
  scope :sorted, -> { order(updated_at: :desc) }
end
