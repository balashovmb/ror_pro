class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource
  before_action :set_question, except: :show

  def index
    respond_with @answers = @question.answers
  end

  def show
    respond_with @answer = Answer.find(params[:id])
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_resource_owner))
    respond_with @answer
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
