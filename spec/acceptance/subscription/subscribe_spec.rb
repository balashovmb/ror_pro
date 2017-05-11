require 'acceptance/acceptance_helper'

feature 'Subscribe ', %q{
  User can subscribe to a newsletter 
  about new answers to question
} do
  let(:user) { create :user }
  let(:question) { create :question }

  context 'non authenticated user' do
    scenario 'could not subscribe on question' do
      visit question_path(question)
      expect(page).not_to have_button 'Subscribe'
    end
  end

  context 'authenticated user' do
    before { sign_in(user) }

    scenario 'subscribe on question', js: true do
      visit question_path(question)
      expect(page).to have_button 'Subscribe'
      click_on 'Subscribe'
      expect(page).to have_button 'Unsubscribe'
    end
  end

  context 'subscribed user' do
    given!(:subscription) { create(:subscription, question: question, user: user) }
    given(:user2) { create(:user) }

    scenario 'gets email when someone answers a question', js: true do
      clear_emails

      sign_in(user2)
      visit question_path(question)
      fill_in 'new-answer-body', with: 'Answers text'
      click_on 'Create answer'
      wait_for_ajax

      open_email(user.email)
      expect(current_email).to have_content 'Answers text'
    end
  end
end