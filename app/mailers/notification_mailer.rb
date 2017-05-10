class NotificationMailer < ApplicationMailer
  def new_answer(user, answer)
    @user = user
    @answer = answer
    mail(to: @user.email, subject: 'New answer to question you subscribed')
  end
end