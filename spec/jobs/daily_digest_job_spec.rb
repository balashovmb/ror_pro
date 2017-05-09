require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do

  it 'executes perform' do
    User.find_each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
    DailyDigestJob.perform_now
  end
end