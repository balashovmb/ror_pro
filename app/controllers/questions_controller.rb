class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :destroy]  

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def index
    @questions = Question.all
  end

  def destroy
    if current_user == @question.user   
      @question.destroy 
      redirect_to questions_path, notice: 'Your question deleted.'
    else
      redirect_to @question, alert: 'No rights to delete' 
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])    
  end

end
