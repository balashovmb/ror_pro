require 'rails_helper'

RSpec.shared_examples 'voted' do
  describe 'PATCH #rate_up' do
    sign_in_user

    let(:model) { create(described_class.controller_name.classify.underscore.to_sym) }

    let(:params) do {
        id: model.id, format: :json
      }
    end

    context "Rate at another post/answer" do
      it "assigns the answer/post to @ratable" do
        patch :vote_up, params: params
        expect(assigns(:ratable)).to eq model
      end

      it "rate up answer/post" do
        expect { patch :vote_up, params: params }.to change{ model.votes.where(user: @user).sum(:votes) }.by(1)
      end
    end
  end
end