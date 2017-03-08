require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_length_of(:body).is_at_least(10) }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(255) }
  it { should have_many(:answers).dependent(:destroy) }  
end

