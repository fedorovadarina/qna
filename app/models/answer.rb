class Answer < ApplicationRecord
  include Votable

  belongs_to :author, class_name: 'User'
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true
  validates :rating, presence: true, numericality: { only_integer: true }

  scope :best_first, -> { order(best: :desc, created_at: :asc) }

  def set_best!
    Answer.transaction do
      status = !best
      question.answers.update_all(best: false)
      update!(best: status)

      question.set_reward!(author)
    end
  end
end
