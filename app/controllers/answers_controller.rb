class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question,       only: [:create, :destroy]
  before_action :set_answer,         only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer deleted.'
    else
      flash[:alert] = 'No rights to delete'
    end
    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
