require 'rails_helper'

shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  describe 'vote methods tests' do
    it 'votes up' do
      model.vote_up(user)

      expect(model.rating).to eq(1)
    end

    it 'votes down' do
      model.vote_down(user)

      expect(model.rating).to eq(-1)
    end

    it 'cancel vote' do
      model.vote_up(user)
      model.cancel_vote(user)

      expect(model.rating).to eq(0)
    end

    it 'sum of the votes of two users' do
      model.vote_up(user)
      model.vote_up(user2)

      expect(model.rating).to eq(2)
    end
  end
end
