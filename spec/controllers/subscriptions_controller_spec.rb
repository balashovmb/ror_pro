require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }
  let(:another_user) { create (:user) }
  sign_in_user

  describe 'POST #create' do
    context 'if user was not subscribed before' do
      it 'creates new subscription in db' do
        expect { post :create, params: { question_id: question }, format: :js }
            .to change(@user.subscriptions.where(question: question), :count).by(1)
      end
    end
  end

  context 'user subscribed' do
    let!(:subscription) { create(:subscription, user: @user, question: question) }

    it 'does not create new record in db' do
      expect { post :create, params: { question_id: question }, format: :js }
          .not_to change(Subscription, :count)
    end
  end

  it 'renders create view' do
    post :create, params: { question_id: question }, format: :js
    expect(response).to render_template :create
  end

  describe 'DELETE #destroy' do
    context 'delete by subscriber' do
      let!(:subscription) { create(:subscription, user: @user) }

      it 'deletes subscription from db' do
        expect { delete :destroy, params: { id: subscription.id }, format: :js }
            .to change(Subscription, :count).by(-1)
      end
    end

    context 'delete by another user' do
      let!(:subscription) { create(:subscription, user: another_user) }

      it 'does not delete subscription from db' do
        expect { delete :destroy, params: { id: subscription.id }, format: :js }
            .not_to change(Subscription, :count)
      end

      it 'responds with status 403 (forbidden)' do
        delete :destroy, params: { id: subscription.id }, format: :js
        expect(response.status).to eq(403)
      end
    end
  end
end
