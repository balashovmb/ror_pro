require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_length_of(:body).is_at_least(10) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }

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
end
