require 'rails_helper'

feature 'Questions list', %q{
  User can view list of questions
} do

  given(:question_list) { create_list(:question_list, 2) }
  given(:user) { create(:user) }

  scenario 'Authenticated can view list of questions' do
    sign_in(user)

    question_list

    visit questions_path
    expect(page).to have_content 'Question title1'
    expect(page).to have_content 'Question body1'
    expect(page).to have_content 'Question title2'
    expect(page).to have_content 'Question body2'
  end

  scenario 'Non-authenticated user can view list of questions' do
    question_list

    visit questions_path
    expect(page).to have_content 'Question title3'
    expect(page).to have_content 'Question body3'
    expect(page).to have_content 'Question title4'
    expect(page).to have_content 'Question body4'
  end
end
