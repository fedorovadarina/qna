module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  RATE = { up: 1, down: -1 }.freeze

  def vote_plus
    voting RATE[:up]
  end

  def vote_minus
    voting RATE[:down]
  end

  private

  def voting(val)
    Vote.transaction do
      votes.create!(user: author, value: val)
      update!(rating: rating + val)
    end
  end
end
