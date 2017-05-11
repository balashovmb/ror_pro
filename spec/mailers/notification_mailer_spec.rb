require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe '#new_answer' do
    let(:user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }
    let(:email) { described_class.new_answer(user, answer) }

    it 'sends email' do
      expect { NotificationMailer.new_answer(user, answer).deliver_now }
        .to change(ActionMailer::Base.deliveries, :count).by 1
    end

    it 'sends email with answer body' do
      expect(email).to have_content answer.body
    end

    it 'receiver is author of answers question' do
      expect(email.to).to eq([answer.question.user.email])
    end
  end
end
