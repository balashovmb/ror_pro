require 'rails_helper'

RSpec.shared_examples 'voted' do
  describe 'POST #vote_up' do
    sign_in_user

    votable_klass = described_class.controller_name.singularize.to_sym
    let(:votable) { create(votable_klass) }
    let(:users_votable){ create(votable_klass, user: @user) } 

    context "Vote for another user's question/answer" do
      it "assigns the answer/post to @votable" do
        post :vote_up, params: { id: votable.id }
        expect(assigns(:votable)).to eq votable
      end

      it "vote up question/answer" do
        expect { post :vote_up, params: { id: votable.id }, format: :js }.to change(@user.votes, :count).by(1)
      end
    end

    it "user is author of question" do
      expect { post :vote_up, params: { id: users_votable.id }, format: :js }.not_to change(@user.votes, :count)      
    end
  end
end