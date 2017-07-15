require 'acceptance/acceptance_helper'

feature 'Delete question', %q{
  Authenticated author of the question can
  delete it
} do
  given!(:question) { create(:question) }
  given(:another_user) { create(:user) }

  context 'Authenticated user' do
    scenario 'can delete his question' do
      sign_in(question.user)

      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Question was successfully destroyed.'
      expect(page).not_to have_content(question.body)
    end

    scenario 'can not see Delete question button near another users questions' do
      sign_in(another_user)

      visit question_path(question)

      expect(page).not_to have_content('Delete question')
    end
  end
  context "mulitple sessions" do
    scenario "question disappears on another user's page", js: true do
      Capybara.using_session('guest') do
        visit questions_path
        expect(page).to have_content(question.title)
      end

      Capybara.using_session('user') do
        sign_in(question.user)
        visit question_path(question)
        click_on 'Delete question'
      end

      Capybara.using_session('guest') do
        expect(page).not_to have_content(question.title)
      end
    end
  end
end