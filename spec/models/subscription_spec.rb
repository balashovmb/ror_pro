require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  describe 'validate uniqueness' do
    subject { create(:subscription) }

    it { should validate_uniqueness_of(:question_id).scoped_to(:user_id) }
  end
end
