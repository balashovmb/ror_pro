require 'rails_helper'

describe 'Answers API' do
  let(:question) { create :question }
  describe 'GET #index' do
    let(:answers) { create_list(:answer, 3) }

    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end
    context 'authorized' do
      let(:access_token) { create :access_token }

      before do
        question.answers << answers
        get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, format: :json }
      end
          it 'responds with status 200' do
        expect(response.status).to eq 200
      end

      it 'returns answers list for certain question' do
        expect(response.body).to have_json_size(1)
        expect(response.body).to have_json_size(3).at_path("answers")
      end

      %w(id body question_id created_at updated_at).each do |attr|
        it "returns #{attr} for each answer" do
          answer = answers.first
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end
  describe 'GET #show' do
    let(:answer) { create(:answer, question: question) }

    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:comments) { create_list(:comment, 3) }
      let(:attachments) { create_list(:attachment, 3) }

      before do
        answer.comments << comments
        answer.attachments << attachments
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token }
      end

      it 'responds with status 200' do
        expect(response.status).to eq 200
      end

      %w(id body question_id created_at updated_at).each do |attr|
        it "contains #{attr} for requested answer" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr} in comment" do
            comment = comments.last
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it "contains url for each question attachment" do
          attachment = attachments.last
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end
      end
    end
  end
  describe 'POST #create' do
    let(:question) { create :question }
    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }
      context 'valid params' do
        it 'returns status 201' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
          expect(response.status).to eq 201
        end

        it 'return success' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
          expect(response).to be_success
        end

        it 'returns attributes of created answer' do
          new_body = "test body12"
          post "/api/v1/questions/#{question.id}/answers", params: { answer: { body: new_body }, access_token: access_token.token, format: :json }
          expect(response.body).to be_json_eql(new_body.to_json).at_path('answer/body')
        end

        it 'saves answer to database' do
          expect do
            post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
          end.to change(user.answers, :count).by(1)
        end
      end

      context 'invalid params' do
        it 'returns status 422' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: { question_id: question.id, body: '' }, format: :json, access_token: access_token.token }
          expect(response.status).to eq 422
        end
      end
    end
  end
end
