require 'rails_helper'

RSpec.shared_examples 'voted' do
  describe 'POST #vote_up' do
    sign_in_user

    votable_klass = described_class.controller_name.singularize.to_sym
    let!(:votable) { create(votable_klass) }
    let(:users_votable) { create(votable_klass, user: @user) }

    context "Vote up for another user's question/answer" do
      it "assigns the answer/post to @votable" do
        post :vote_up, params: { id: votable.id }
        expect(assigns(:votable)).to eq votable
      end

      it "change question/answer rating to 1" do
        expect { post :vote_up, params: { id: votable.id }, format: :js }.to change { votable.reload.rating }.by(1)
      end
    end

    context "Vote down for another user's question/answer" do
      it "assigns the answer/post to @votable" do
        post :vote_down, params: { id: votable.id }
        expect(assigns(:votable)).to eq votable
      end

      it "change question/answer rating to -1" do
        expect { post :vote_down, params: { id: votable.id }, format: :js }.to change { votable.reload.rating }.by(-1)
      end
    end

    context "User is author of question" do
      it "vote up don't changes rating" do
        expect { post :vote_up, params: { id: users_votable.id }, format: :js }.not_to change { votable.reload.rating }
      end

      it "vote down don't changes rating" do
        expect { post :vote_down, params: { id: users_votable.id }, format: :js }.not_to change { votable.reload.rating }
      end
    end

    context "Cancel vote" do
      it "deletes vote" do
        post :vote_up, params: { id: votable.id }, format: :js
        delete :cancel_vote, params: { id: votable.id }, format: :js
        expect(votable.reload.rating).to eq 0
      end
    end
  end
end
