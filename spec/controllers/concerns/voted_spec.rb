require 'rails_helper'

RSpec.shared_examples 'voted' do
  votable_klass = described_class.controller_name.singularize.to_sym
  let!(:votable) { create(votable_klass) }
  let(:users_votable) { create(votable_klass, user: @user) }

  sign_in_user

  describe 'POST #vote_up' do
    subject(:vote_up) { post :vote_up, params: { id: votable.id }, format: :json }

    sign_in_user

    it "assigns the answer/question to @votable" do
      vote_up
      expect(assigns(:votable)).to eq votable
    end

    it "change question/answer rating to 1" do
      expect { vote_up }.to change { votable.reload.rating }.by(1)
    end

    it "renders json" do
      vote_up
      expect(response.headers['Content-Type']).to match /json/
    end

    context "User is author of question" do
      subject(:vote_up_own_voteble) { post :vote_up, params: { id: users_votable.id }, format: :json }

      it "vote up don't changes rating" do
        expect { vote_up_own_voteble }.not_to change { votable.reload.rating }
      end
      it "renders json" do
        vote_up_own_voteble
        expect(response.headers['Content-Type']).to match /json/
      end
    end
  end
  describe 'POST #vote_down' do
    sign_in_user

    subject(:vote_down) { post :vote_down, params: { id: votable.id }, format: :json }

    context "Vote down for another user's question/answer" do
      it "assigns the answer/question to @votable" do
        vote_down
        expect(assigns(:votable)).to eq votable
      end

      it "change question/answer rating to -1" do
        expect { vote_down }.to change { votable.reload.rating }.by(-1)
      end
    end

    context "User is author of question" do
      subject(:vote_down_own_voteble) { post :vote_down, params: { id: users_votable.id }, format: :json }

      it "vote down don't changes rating" do
        expect { vote_down_own_voteble }.not_to change { votable.reload.rating }
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    subject(:vote_and_cancel) do
      post :vote_up, params: { id: votable.id }, format: :json
      delete :cancel_vote, params: { id: votable.id }, format: :json
    end

    sign_in_user

    it "deletes vote" do
      vote_and_cancel
      expect(votable.reload.rating).to eq 0
    end

    it "renders json" do
      vote_and_cancel
      expect(response.headers['Content-Type']).to match /json/
    end
  end
end
