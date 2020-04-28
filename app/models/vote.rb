class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, presence: true, numericality: { only_integer: true }
  validates :votable_type, inclusion: %w[Question Answer]
end
