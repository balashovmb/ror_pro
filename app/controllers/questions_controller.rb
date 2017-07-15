class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :destroy, :update]
  before_action :new_answer, only: :show
  before_action :check_subscription, only: :show

  after_action :publish_question, only: [:create]
  after_action :delete_question_broadcast, only: [:destroy]

  respond_to :js, :json

  authorize_resource

  def new
    respond_with(@question = Question.new)
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with(@question)
  end

  def index
    respond_with(@questions = Question.all)
  end

  def destroy
    respond_with(@question.destroy)
  end

  def update
    respond_with(@question.update(question_params))
  end

  def show
    respond_with(@question)
  end

  private

  def new_answer
    @answer = @question.answers.new
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def delete_question_broadcast
    data = {
      type: :delete_question,
      question_id: @question.id      
    }
    ActionCable.server.broadcast('questions', data)
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy, :id])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def check_subscription
    @subscription = Subscription.find_or_initialize_by(user: current_user, question: @question) if
      can?(:create, Subscription)
  end
end
