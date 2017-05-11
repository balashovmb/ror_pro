require 'rails_helper'

RSpec.describe AnswersNotificationJob, type: :job do
  include ActiveJob::TestHelper
  let(:question) { create :question }
  let!(:subscriptions) { create_list(:subscription,3, question: question) }
  let(:answer) { create :answer, question: question }

  it 'sends emails to subscribers' do
    answer.question.subscriptions.each do |subscription|
      expect(NotificationMailer).to receive(:new_answer).with(subscription.user, answer).and_call_original
    end
    AnswersNotificationJob.perform_now(answer)
  end
end