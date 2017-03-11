require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions) }
  it { should have_many(:answers) }  

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