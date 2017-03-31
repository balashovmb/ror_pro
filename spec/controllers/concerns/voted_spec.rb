require 'rails_helper'

RSpec.shared_examples 'voted' do
  describe 'POST #vote_up' do
    sign_in_user

    let(:votable) { create(described_class.controller_name.classify.underscore.to_sym) }

    let(:params) do {
        id: votable.id
      }
    end

    context "Vote for another user's question/answer" do
      it "assigns the answer/post to @votable" do
        post :vote_up, params: params
        expect(assigns(:votable)).to eq votable
      end

      it "vote up question/answer" do
        expect { post :vote_up, method: :post, params: { id: votable }, format: :js }.to change(@user.votes, :count).by(1)
      end
    end
  end
end