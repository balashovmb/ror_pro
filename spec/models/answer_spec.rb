require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_length_of(:body).is_at_least(10) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  let(:answer) { create(:answer) }

  context 'set_best method' do
    it 'changes attribute best to true' do
      answer.set_best
      expect(answer.best).to eq true
    end
  end
end
