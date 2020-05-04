class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: %i[create]
  after_action :publish, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.author = current_user

    if @comment.save
      render_comment
    else
      render_errors
    end
  end

  private

  def model_klass
    params[:commentable].classify.constantize
  end

  def set_commentable
    model_klass_name = params[:commentable]
    @commentable = model_klass.find(params["#{model_klass_name}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def render_comment
    respond_to do |format|
      format.json do
        render json: comment_json_data
      end
    end
  end

  def render_errors
    respond_to do |format|
      format.json do
        render json: @comment.errors, status: :unprocessable_entity
      end
    end
  end

  def publish
    return if @comment.errors.present?

    ActionCable.server.broadcast "question#{question_id}:comments", comment_json_data
  end

  def question_id
    if @commentable.is_a? Answer
      @commentable.question.id
    else
      @commentable.id
    end
  end

  def comment_json_data
    { resource: @commentable.class.name.downcase,
      resource_id: @commentable.id,
      id: @comment.id,
      author: @comment.author,
      updated_at: @comment.updated_at.to_datetime.to_formatted_s(:db),
      body: @comment.body }
  end
end