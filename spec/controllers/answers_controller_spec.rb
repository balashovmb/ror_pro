require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { question.answers.create(attributes_for(:answer)) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns the question selected to give an answer to @question' do
      expect(assigns[:question]).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
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

      it 're-renders new view' do
        create_invalid_answer
        expect(response).to render_template :new
      end
    end
  end
end
