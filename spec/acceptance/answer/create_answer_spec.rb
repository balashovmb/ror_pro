require 'rails_helper'

feature 'Create answer', %q{
  In order to help somebody who asked the question
  As an authenticated user
  I want to be able to give answers
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)

    question = create(:question)

    visit question_path(question)
    fill_in 'Body', with: 'text text12'
    click_on 'Create answer'

    expect(page).to have_content 'Your answer successfully created.'
    within '.answers' do 
      expect(page).to have_content 'text text12' 
    end
  end

  scenario 'Non-authenticated user can not see Create answer button' do
    question = create(:question)

    visit question_path(question)
    expect(page).not_to have_content('Create answer')
  end
end
