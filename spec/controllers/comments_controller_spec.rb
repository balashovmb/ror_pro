require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "POST #create" do
    context 'with valid attributes' do
      sign_in_user
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer) }
      let(:create_comment) { post :create,\ params: { commentable: 'question', question_id: question.id, comment: { body: "comment"} }, format: :js }
      let(:answers_comment) { post :create, params: { commentable: 'answer', answer_id: answer.id, comment: { body: "comment"} }, format: :js }
      it "saves question's comment to database" do
        expect { create_comment }.to change(question.comments.where(user: @user), :count).by(1)
      end
      it "saves answer's comment to database" do
        expect { answers_comment }.to change(answer.comments.where(user: @user), :count).by(1)
      end
    end
  end

  # describe "DELETE #destroy" do
  #   it "returns http success" do
  #     delete :destroy
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
