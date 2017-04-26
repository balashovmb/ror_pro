require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #facebook' do
    context 'without onmiauth' do
      before do
        get :facebook
      end

      it 'should redirect_to new user registration' do
        expect(response).to redirect_to new_user_registration_path
      end
    end

    context 'new user' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345',
          info: { email: 'test@mail.com' })
        get :facebook
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to be_a(User)
      end
    end

    context 'without onmiauth' do
      before do
        get :facebook
      end

      it 'should redirect_to new user registration' do
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end

  describe 'GET #twitter' do
    context 'without email' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '12345')
        get :twitter
      end

      it 'stores data in session' do
        expect(session['provider']).to eq 'twitter'
        expect(session['uid']).to eq '12345'
      end

      it { should_not be_user_signed_in }
      it { expect(response).to render_template :set_email }
    end

    context 'new user' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '12345', info: { email: 'twitter@mail.com' })
        get :twitter
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to be_a(User)
      end
    end
  end
end
