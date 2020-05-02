class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  RATE = { plus: 1, minus: -1 }.freeze

  validates :value, presence: true, inclusion: { in: RATE.values }
  validates :votable_type, inclusion: %w[Question Answer]
  validate :validate_user_not_author

  def vote_plus
    vote(:plus)
  end

  def vote_minus
    vote(:minus)
  end

  private

  def vote(key)
    case
    when same_vote?(key)
      delete
    when switch_vote?(key)
      switch
    when new_vote?
      new_vote(key)
    end
  end

  def same_vote?(key)
    persisted? && value == RATE[key]
  end

  def switch_vote?(key)
    persisted? && value != RATE[key]
  end

  def new_vote?
    new_record?
  end

  def delete
    destroy!
  end

  def switch
    update!(value: value * -1)
  end

  def new_vote(key)
    update!(value: RATE[key])
  end

  def validate_user_not_author
    errors.add(:user, message: "User can't vote for your own #{votable_type}") if user&.author_of?(votable)
  end
end
