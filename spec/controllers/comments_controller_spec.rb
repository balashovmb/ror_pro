require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "POST #create" do
    sign_in_user
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer) }    
    context 'with valid attributes' do
      let(:questions_comment) { post :create, params: { commentable: 'question', question_id: question.id, comment: { body: "comment"} }, format: :js }
      let(:answers_comment) { post :create, params: { commentable: 'answer', answer_id: answer.id, comment: { body: "comment"} }, format: :js }
      it "saves question's comment to database" do
        expect { questions_comment }.to change(question.comments.where(user: @user), :count).by(1)
      end
      it "saves answer's comment to database" do
        expect { answers_comment }.to change(answer.comments.where(user: @user), :count).by(1)
      end
    end
    context 'with invalid attributes' do
      let(:questions_invalid_comment) { post :create, params: { commentable: 'question', question_id: question.id, comment: { body: ""} }, format: :js }
      let(:answers_invalid_comment) { post :create, params: { commentable: 'answer', answer_id: answer.id, comment: { body: ""} }, format: :js }
      it "don't saves question's comment to database" do
        expect { questions_invalid_comment }.not_to change(question.comments.where(user: @user), :count)
      end
      it "don't saves answer's comment to database" do
        expect { answers_invalid_comment }.not_to change(answer.comments.where(user: @user), :count)
      end
    end   
  end

  describe "DELETE #destroy" do
    sign_in_user
    context "user is an author" do
      let!(:comment) { create(:comment, user: @user) } 
      it "deletes comment from database" do
        expect { delete :destroy, params:{ id: comment.id}, format: :js }.to change(Comment, :count).by(-1)
      end
    end
    context "user is not an author" do
      let!(:comment) { create(:comment) } 
      it "don't deletes comment from database" do
        expect { delete :destroy, params:{ id: comment.id}, format: :js }.not_to change(Comment, :count)
      end
    end    
  end
end
