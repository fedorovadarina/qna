class AnswersController < ApplicationController
  before_action :find_question, only: [:new, :create]

  def new
    @answer = @question.answers.new(answer_params)
  end

  def create
    @answer = @question.answers.create(answer_params)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
