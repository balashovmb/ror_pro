class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :destroy, :update]
  before_action :new_answer, only: :show

  after_action :publish_question, only: [:create]

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

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy, :id])
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
