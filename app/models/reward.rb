class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :name, presence: true
  validate :image_presence

  private

  def image_presence
    errors.add(:image, "must be added") unless image.attached?
  end
end
