require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end
  describe 'GET #show' do
    let(:question) { create :question }

    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end
    context 'authorized' do
      let!(:access_token) { create :access_token }
      let!(:comments) { create_list(:comment, 2) }
      let!(:attachments) { create_list(:attachment, 2) }

      before do
        question.comments << comments
        question.attachments << attachments
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
      end
      it 'returns status 200' do
        expect(response.status).to eq 200
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr} in question" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
      context 'comments' do
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr} in comment" do
            comment = comments.last
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end
      context 'attachments' do
        it "contains url for each question attachment" do
          attachment = attachments.last
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end
      end
    end
  end

  describe 'POST #create' do
    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        post "/api/v1/questions", params: { question: attributes_for(:question), format: :json }
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        post "/api/v1/questions", params: { question: attributes_for(:question), format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end
    context 'authorized' do
      let!(:user) { create :user }
      let!(:access_token) { create :access_token, resource_owner_id: user.id }
      context 'valid params' do
        it 'returns status 201' do
          post "/api/v1/questions", params: { question: attributes_for(:question), format: :json, access_token: access_token.token }
          expect(response.status).to eq 201
        end

        it 'returns success' do
          post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token }
          expect(response).to be_success
        end

        it 'return question json with new body' do
          new_body = "test body1"
          post '/api/v1/questions', params: { question: attributes_for(:question, body: new_body), format: :json, access_token: access_token.token }
          expect(response.body).to be_json_eql(new_body.to_json).at_path("question/body")
        end

        it 'return question json with new title' do
          new_title = "test title"
          post '/api/v1/questions', params: { question: attributes_for(:question, title: new_title), format: :json, access_token: access_token.token }
          expect(response.body).to be_json_eql(new_title.to_json).at_path("question/title")
        end

        it 'saves question to database' do
          expect { post "/api/v1/questions", params: { question: attributes_for(:question), format: :json, access_token: access_token.token } }
            .to change(user.questions, :count).by(1)
        end
      end

      context 'invalid params' do
        it 'returns status 422' do
          post "/api/v1/questions", params: { question: attributes_for(:question, title: ''), format: :json, access_token: access_token.token }
          expect(response.status).to eq 422
        end
      end
    end
  end
end
