require 'rails_helper'

feature 'Delete question', %q{
  Authenticated author of the question can
  delete it
} do
  given(:question) { create(:question) }
  given(:another_user) { create(:user) }

  context 'Authenticated user' do
    scenario 'can delete his question' do
      sign_in(question.user)

      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question deleted.'
      expect(page).not_to have_content(question.body)
    end

    scenario 'can not see Delete question button near another users questions' do
      sign_in(another_user)

      visit question_path(question)

      expect(page).not_to have_content('Delete question')
    end
  end
end
