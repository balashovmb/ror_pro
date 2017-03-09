class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show]  

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def index
    @questions = Question.all
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])    
  end

end
