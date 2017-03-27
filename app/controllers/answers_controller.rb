class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :set_best]
  before_action :set_question,       only: [:create]
  before_action :set_answer,         only: [:destroy, :update, :set_best]

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
  end

  def update
    if current_user.author?(@answer)
      @answer.update(answer_params)
      flash[:notice] = 'Your answer updated.'
    else
      flash[:alert] = 'No rights to edit answer.'
    end
  end

  def set_best
    @answer.set_best if current_user.author?(@answer.question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy, :id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
