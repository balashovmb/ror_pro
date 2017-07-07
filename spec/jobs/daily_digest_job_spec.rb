require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  include ActiveJob::TestHelper

  let(:users) { create_list(:user, 2) }
  let(:user) { create(:user, digest_subscription: false) }

  it 'sends daily digest to each subscribed user' do
    User.where(digest_subscription: :true).each { |_user| expect(DailyMailer).to receive(:digest).and_call_original }
    DailyDigestJob.perform_now
  end

  it "don't sends daily digest to unsubscribed users" do
    User.where(digest_subscription: :false).each { |_user| expect(DailyMailer).not_to receive(:digest) }
    DailyDigestJob.perform_now
  end
end
