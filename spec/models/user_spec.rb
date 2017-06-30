require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '#author?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:question2) { create(:question) }

    it 'returns true if user is the author of that question' do
      expect(user.author?(question)).to eq true
    end

    it 'returns false if user is the author of that question' do
      expect(user.author?(question2)).to eq false
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(described_class.find_for_oauth(auth)). to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it "does not create new user" do
          expect { described_class.find_for_oauth(auth) }.not_to change(described_class, :count)
        end

        it "creates authorization for user" do
          expect { described_class.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = described_class.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(described_class.find_for_oauth(auth)).to eq user
        end
      end
      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { described_class.find_for_oauth(auth) }.to change(described_class, :count).by(1)
        end

        it 'returns new user' do
          expect(described_class.find_for_oauth(auth)).to be_a(described_class)
        end

        it 'fills user email' do
          user = described_class.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = described_class.find_for_oauth(auth)
          expect(user.authorizations).not_to be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = described_class.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
