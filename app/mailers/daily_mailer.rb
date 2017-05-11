class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: Time.zone.yesterday...Time.zone.today)
    mail(to: user.email, subject: 'Daily digest')
  end
end
