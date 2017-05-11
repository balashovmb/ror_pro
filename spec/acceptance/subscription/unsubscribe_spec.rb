require 'acceptance/acceptance_helper'

feature 'Unsubscribe', %q{
  Subscriber can cancel the subscription
  for answers to the question
  to
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'subscribed user' do
    given!(:subscription) { create(:subscription, question: question, user: user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can see "Unsubscribe" button' do
      expect(page).to have_button 'Unsubscribe'
    end

    scenario 'can unsubscribe a question', js: true do
      click_on 'Unsubscribe'
      expect(page).not_to have_link 'Unsubscribe'
      expect(page).to have_button 'Subscribe'
    end
  end

  context 'not subscribed user' do
    scenario 'can not see "unsubscribe" button' do
      sign_in(user)
      visit question_path(question)

      expect(page).not_to have_button 'Unsubscribe'
    end

    scenario 'does not get email when someone answers a question', js: true do
      clear_emails

      sign_in(create(:user))
      visit question_path(question)
      fill_in 'new-answer-body', with: 'Answers text'
      click_on 'Create answer'
      wait_for_ajax

      expect(emails_sent_to(user.email)).to be_empty
    end
  end
end
