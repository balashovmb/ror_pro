require 'acceptance/acceptance_helper'

feature 'Answer editing', %{
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:answer) { create(:answer) }
  given(:user) { create(:user) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(answer.question)

    expect(page).not_to have_button 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(answer.user)
      visit question_path(answer.question)
    end

    scenario 'author sees button to edit' do
      within '.answers' do
        expect(page).to have_button 'Edit'
      end
    end

    scenario 'author try to edit his answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'
        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end
  end

  scenario "try to edit other user's answer" do
    sign_in(user)
    visit question_path(answer.question)

    expect(page).not_to have_button 'Edit'
  end
end
