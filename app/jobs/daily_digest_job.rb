class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    User.where(digest_subscription: true).find_each { |user| DailyMailer.digest(user).deliver_now }
  end
end
