class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  RATE = { plus: 1, minus: -1 }.freeze
  STATES = %w[author vote delete switch].freeze

  validates :value, presence: true, inclusion: { in: RATE.values }
  validates :votable_type, inclusion: %w[Question Answer]

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

  def author?(_key)
    user == votable.author
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

  def author(_val)
  rescue StandardError => e
    e.message = "You can't vote for your own item"
  end

  def delete(val)
    Vote.transaction do
      votable.update!(rating: votable.rating - val)
      destroy!
    end
  end

  def switch(val)
    Vote.transaction do
      update!(value: value * -1)
      votable.update!(rating: votable.rating + val * 2)
    end
  end

  def vote(val)
    Vote.transaction do
      update!(value: val)
      votable.update!(rating: votable.rating + val)
    end
  end
end
