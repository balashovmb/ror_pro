require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  context 'guest' do
    let(:user) { nil }
    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  context 'authorized user' do
    let(:user) { create :user }
    let(:another_user) { create :user }

    let(:question) { create :question, user: user }
    let(:question2) { create :question, user: another_user }

    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Attachment }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should be_able_to :destroy, create(:attachment, attachable: question) }
    it { should be_able_to :destroy, create(:comment, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: another_user) }
    it { should_not be_able_to :destroy, create(:answer, user: another_user) }
    it { should_not be_able_to :destroy, create(:attachment, attachable: question2) }
    it { should_not be_able_to :destroy, create(:comment, user: another_user) }

    it { should be_able_to :update, create(:question, user: user) }
    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:question, user: another_user) }
    it { should_not be_able_to :update, create(:answer, user: another_user) }

    it { should be_able_to :vote, create(:question, user: another_user) }
    it { should be_able_to :vote, create(:answer, user: another_user) }
    it { should_not be_able_to :vote, create(:question, user: user) }
    it { should_not be_able_to :vote, create(:answer, user: user) }

    it { should be_able_to :set_best, create(:answer, question: question) }
    it { should_not be_able_to :set_best, create(:answer, question: question2) }
  end
end 