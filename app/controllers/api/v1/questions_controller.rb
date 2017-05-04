class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    respond_with @questions = Question.all
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    respond_with @question
  end

  def show
    respond_with @question = Question.find(params[:id])
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
