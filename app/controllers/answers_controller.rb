class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question,       only: [:create, :destroy, :update]
  before_action :set_answer,         only: [:destroy, :update]

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

  def update
    if current_user.author?(@answer)    
      @answer.update(answer_params)
      flash[:notice] = 'Your answer updated.'
    else
      flash[:alert] = 'No rights to edit answer.'
    end      
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
