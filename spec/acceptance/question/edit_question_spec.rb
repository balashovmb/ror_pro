require 'acceptance/acceptance_helper'

feature 'Question editing', %{
  In order to fix mistake
  As an author of question
  I'd like to be able to edit my question
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do

    before do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario 'author sees link to edit' do
      expect(page).to have_link 'Edit question'
    end

    scenario 'author try to edit his question', js: true do
      click_on 'Edit question'
      within '.question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'

        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario "try to edit other user's question" do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end
