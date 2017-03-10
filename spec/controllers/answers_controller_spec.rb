require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { question.answers.create(attributes_for(:answer)) }

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
end
