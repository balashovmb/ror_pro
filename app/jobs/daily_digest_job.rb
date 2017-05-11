class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    User.find_each { |user| DailyMailer.digest(user).deliver_later }
  end
end
