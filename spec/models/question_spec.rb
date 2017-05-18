require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like "attachable"
  it_behaves_like "votable"
  it_behaves_like "commentable"

  it { should validate_length_of(:body).is_at_least(5) }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(255) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '#subscribe_author' do
    let(:user) { create :user }
    let(:question) { build(:question, user: user) }

    it 'subscribes question owner on question' do
      expect { question.save }.to change(user.subscriptions, :count).by(1)
    end

    it 'performs after question has been created' do
      expect(question).to receive(:subscribe_author)
      question.save
    end
  end
end
