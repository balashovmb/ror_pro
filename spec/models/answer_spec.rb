require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like "attachable"
  it_behaves_like "votable"
  it_behaves_like "commentable"

  it { should validate_length_of(:body).is_at_least(5) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  context 'set_best method' do
    let(:question) { create(:question) }
    let(:answer1) { create(:answer, question: question) }
    let(:answer2) { create(:answer, question: question, best: false) }

    it 'changes attribute best to true' do
      answer1.set_best
      expect(answer1.best).to eq true
    end

    it 'changes attribute best of another answers of that question to false' do
      answer1.set_best
      answer2.set_best
      answer1.reload
      expect(answer1.best).to eq false
    end
  end
  describe 'Send notifications after create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { build :answer, question: question }

    it 'should push notification job to queue after answer create' do
      expect(AnswersNotificationJob).to receive(:perform_later)
      answer.save!
    end

    it 'should not create job after update' do
      answer.save!
      expect(AnswersNotificationJob).not_to receive(:perform_later)
      answer.update!(body: 'updated body')
    end
  end
end
