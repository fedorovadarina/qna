module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down]
  end

  def vote_up
    if @votable.vote_plus
      render_rating
    else
      render_errors
    end
  end

  def vote_down
    if @votable.vote_minus
      render_rating
    else
      render_errors
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def render_rating
    respond_to do |format|
      format.json do
        render json: { resource: @votable.class.name.downcase, rating: @votable.rating }
      end
    end
  end

  def render_errors
    respond_to do |format|
      format.json do
        render json: @votable.errors.full_messages, status: :unprocessable_entity
      end
    end
  end
end
