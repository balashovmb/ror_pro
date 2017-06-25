class AnswersNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each do |subscription|
      NotificationMailer.new_answer(subscription.user, answer).deliver_now if answer.user_id != subscription.user_id
    end
  end
end
