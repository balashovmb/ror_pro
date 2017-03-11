require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_length_of(:body).is_at_least(10) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }      
end
