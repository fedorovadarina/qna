class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: :destroy
  before_action :find_question, only: [:create, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Answer successfully created'
    else
      flash.now[:alert] = "Please, enter answer's text"
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer successfully deleted'
    else
      flash.now[:alert] = 'Only author can delete answer'
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = @answer&.question || Question.find(params[:question_id])
  end
end
