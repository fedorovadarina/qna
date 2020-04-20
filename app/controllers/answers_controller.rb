class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: [:update, :destroy, :best]
  before_action :find_question, only: [:create, :update, :destroy, :best]
  before_action :authority!, only: [:update, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      flash.now[:notice] = 'Answer successfully created'
    else
      flash.now[:alert] = "Please, enter text of answer"
    end
  end

  def update
    if @answer.update(answer_params)
      flash.now[:notice] = 'Answer successfully edited'
    else
      flash.now[:alert] = 'Editing answer failed'
    end
  end

  def destroy
    @answer.destroy
    flash.now[:notice] = 'Answer successfully deleted'
  end

  def best
    if current_user.author_of?(@question)
      @answer.set_best!
    else
      flash.now[:alert] = 'You must be the author of question'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

  def authority!
    unless current_user.author_of?(@answer)
      flash.now[:alert] = 'You must be the author of answer'
      render 'questions/show'
    end
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = @answer&.question || Question.find(params[:question_id])
  end
end
