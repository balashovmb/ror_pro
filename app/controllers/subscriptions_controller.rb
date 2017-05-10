class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, only: :destroy

  respond_to :js

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    respond_with(@subscription = current_user.subscriptions.create(question: @question))
  end

  def destroy
    respond_with(@subscription.destroy)
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end
