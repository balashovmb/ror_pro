require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let!(:user) { question.user }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:another_user) {create(:user)}

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:create_answer) { post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js }
      it 'saves the new answer in the database' do
        expect { create_answer }.to change(Answer, :count).by(1)
      end

      it 'renders create template' do
        create_answer
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_answer) { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer), format: :js } }
      it 'does not save the question' do
        expect { create_invalid_answer }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        create_invalid_answer
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user is author of the answer' do
      before { sign_in(user) }
      before { answer }

      it 'delete answer' do
        expect { delete :destroy, params: { question_id: answer.question.id, id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirect_to index view' do
        delete :destroy, params: { question_id: answer.question.id, id: answer, format: :js }
        expect(response).to render_template 'answers/destroy' 
      end
    end
  end

  describe 'PATCH #update' do
    context 'user is author of the answer ' do      
      before { sign_in(user) }

      it 'assigns the requested answer to @answer' do
        patch :update, params:{ id: answer, question_id: question, answer: attributes_for(:answer)}, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body12'}}, format: :js
        answer.reload
        expect(answer.body).to eq 'new body12'       
      end

      it 'renders update template' do
        patch :update, params:{ id: answer, question_id: question, answer: attributes_for(:answer)}, format: :js
        expect(response).to render_template :update    
      end
    end

    context 'user is not author of the answer' do  
      before { sign_in(another_user) }
      
      it 'do not edit answer' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body12'}}, format: :js
        question.reload    
        expect(answer.body).to_not eq 'new body12'         
      end
    end    
  end
end
 