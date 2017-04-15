class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :destroy, :update]

  after_action :publish_question, only: [:create]

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
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question deleted.'
    else
      redirect_to @question, alert: 'No rights to delete.'
    end
  end

  def update
    if current_user.author?(@question)
      @question.update(question_params)
      flash[:notice] = 'Your question updated.'
    else
      flash[:alert] = 'No rights to edit question.'
    end
  end

  def show
    @answer = @question.answers.new
  end

  private

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
