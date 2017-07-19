class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:create, :destroy, :update, :set_best]
  before_action :set_question,       only: [:create]
  before_action :set_answer,         only: [:destroy, :update, :set_best]

  after_action :publish_answer, only: [:create]
  after_action :delete_answer_broadcast, only: [:destroy]

  respond_to :js, :json

  authorize_resource

  def create
    @answer = current_user.answers.create(answer_params.merge(question_id: @question.id))
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def update
    respond_with(@answer.update(answer_params))
  end

  def set_best
    respond_with(@answer.set_best)
  end

  private

  def publish_answer
    return if @answer.errors.any?
    data = {
      type: :answer,
      answer: @answer,
      question_author_id: @question.user_id,
      rating: @answer.rating,
      attachments: @answer.attachments.as_json(methods: :with_meta)
    }
    broadcast_data(data)
  end

  def delete_answer_broadcast
    @question = @answer.question
    data = {
      action: :delete,
      type: :answer,
      answer_id: @answer.id
    }
    broadcast_data(data)
  end

  def broadcast_data(data)
    ActionCable.server.broadcast("question_answers_#{@question.id}", data)
  end

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
