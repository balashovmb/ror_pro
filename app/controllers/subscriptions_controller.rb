class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, only: :destroy
  before_action :set_question, only: :create
  before_action :set_question_after_destroy, only: :destroy

  respond_to :js

  authorize_resource

  def create
    respond_with(@subscription = current_user.subscriptions.create(question: @question))
  end

  def destroy
    respond_with(@subscription.destroy)
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_question_after_destroy
    @question = @subscription.question
  end
end
