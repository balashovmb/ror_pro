require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { question.user }
  let(:answer) { question.answers.create(body: "1234567890", user: user) }
 
  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:create_answer) { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }
      it 'saves the new answer in the database' do
        expect { create_answer }.to change(Answer, :count).by(1)
      end
      it 'redirects to show view' do
        create_answer
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_answer) { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) } }
      it 'does not save the question' do
        expect { create_invalid_answer }.to_not change(Answer, :count)
      end

      it 'renders questions' do
        create_invalid_answer
        expect(response).to render_template "questions/show" 
      end
    end
  end


  describe 'DELETE #destroy' do
    context 'user is author of the answer' do    
      before { sign_in(user) }
      before { question }
      before { answer }

      it 'delete answer' do
        expect { delete :destroy, params:{ question_id: answer.question.id, id: answer } }.to change(Answer, :count ).by(-1)
      end

      it 'redirect_to index view' do
        delete :destroy, params: { question_id: answer.question.id, id: answer }
        expect(response).to redirect_to question_path(question) 
      end
    end 
    
  end
end
