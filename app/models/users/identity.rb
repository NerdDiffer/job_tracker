module Users
  class Identity < ActiveRecord::Base
    belongs_to :user, inverse_of: :identity, class_name: 'User'
    belongs_to :identifiable, polymorphic: true

    validates :user, presence: true
    validates :identifiable, presence: true
    validates :identifiable_id, uniqueness: { scope: :identifiable_type }
    validates_associated :user
  end
end
