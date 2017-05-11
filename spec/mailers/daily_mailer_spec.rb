require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe '#digest' do
    let(:users) { create_list(:user, 2) }
    let(:questions) { create_list(:question, 2, created_at: Time.current.midnight - 1.hour) }
    let(:email) { DailyMailer.digest(users.first) }

    it 'sends emails to each user' do
      users.each do |user|
        expect { DailyMailer.digest(user).deliver_now }.to change(ActionMailer::Base.deliveries, :count).by 1
      end
    end

    it 'sends email with question titles' do
      questions.each do |question|
        expect(email).to have_content question.title
      end
    end
  end
end
