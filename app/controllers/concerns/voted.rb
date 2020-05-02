module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
    before_action :set_vote, only: [:vote_up, :vote_down]

    rescue_from ActiveRecord::RecordInvalid, with: :render_errors
  end

  def vote_up
    if @vote.vote_plus
      render_rating
    else
      render_errors
    end
  end

  def vote_down
    if @vote.vote_minus
      render_rating
    else
      render_errors
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_vote
    @vote = current_user.votes.find_by(votable: @votable) || Vote.new(user: current_user, votable: @votable)
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def render_rating
    respond_to do |format|
      format.json do
        render json: { resource: @votable.class.name.downcase, rating: @vote.votable.rating }
      end
    end
  end

  def render_errors
    respond_to do |format|
      format.json do
        render json: @vote.errors, status: :unprocessable_entity
      end
    end
  end
end
