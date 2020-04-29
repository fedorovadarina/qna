class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  RATE = { plus: 1, minus: -1 }.freeze
  STATES = %w[vote delete switch].freeze

  validates :value, presence: true, inclusion: { in: RATE.values }
  validates :votable_type, inclusion: %w[Question Answer]
  validate :validate_user_not_author

  def vote_plus
    send state(:plus), RATE[:plus]
  end

  def vote_minus
    send state(:minus), RATE[:minus]
  end

  private

  def state(key)
    STATES.lazy.select do |s|
      send("#{s}?".to_sym, key)
    end.first
  end

  def delete?(key)
    persisted? && value == RATE[key]
  end

  def switch?(key)
    persisted? && value != RATE[key]
  end

  def vote?(_key)
    new_record?
  end

  def delete(_val)
    destroy!
  end

  def switch(_val)
    update!(value: value * -1)
  end

  def vote(val)
    update!(value: val)
  end

  def validate_user_not_author
    errors.add(:user, "can't vote for your own #{votable_type}") if user&.author_of?(votable)
  end
end
