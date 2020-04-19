class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  before_action :load_question, only: [:show, :update, :destroy, :best_answer]
  before_action :authority!, only: [:update, :destroy, :best_answer]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def update
    if @question.update(question_params)
      flash.now[:notice] = 'Question successfully edited'
    else
      flash.now[:alert] = 'Question editing failed'
    end
  end

  def create
    @question = Question.create(question_params)
    @question.author = current_user

    if @question.save
      redirect_to @question, notice: 'Question successfully created'
    else
      flash.now[:alert] = 'Please, enter valid data'
      render :new
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question successfully deleted'
  end

  private

  def authority!
    unless current_user.author_of?(@question)
      flash.now[:alert] = 'You must be the author of question'
      render :show
    end
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
