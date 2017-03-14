require 'acceptance/acceptance_helper'

feature 'Delete answer', %q{
  Authenticated author of the answer can
  delete it
} do

  given(:answer) { create(:answer) }
  given(:another_user) { create(:user) }

  context 'Authenticated user' do
    scenario 'can delete his answer' do
      sign_in(answer.user)

      visit question_path(answer.question)
      click_on 'Delete answer'

      expect(page).to have_content 'Your answer deleted.'
      expect(page).not_to have_content(answer.body)
    end

    scenario 'can not see Delete answer button near another users answer' do
      sign_in(another_user)

      visit question_path(answer.question)

      expect(page).not_to have_content('Delete answer')
    end
  end

  context 'Non-authenticated user' do
    scenario 'can not see Delete button near any answers' do
      visit question_path(answer.question)

      expect(page).not_to have_content('Delete answer')
    end
  end
end
