require 'acceptance/acceptance_helper'

feature 'Create answer', %q{
  In order to help somebody who asked the question
  As an authenticated user
  I want to be able to give answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)

    visit question_path(question)  
    fill_in 'Answer', with: 'text text12'
    click_on 'Create answer'
    within '.answers' do
      expect(page).to have_content 'text text12'
    end
  end

  scenario 'Non-authenticated user can not see Create answer button' do
    visit question_path(question)
    expect(page).not_to have_button('Create answer')
  end

  scenario 'User try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Create answer'

    expect(page).to have_content "Body is too short"
  end
end
