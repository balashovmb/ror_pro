require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  include ActiveJob::TestHelper

  let(:users) { create_list(:user, 2) }

  it 'sends daily digest to each user' do
    users.each { |_user| expect(DailyMailer).to receive(:digest).and_call_original }
    DailyDigestJob.perform_now
  end
end
