require 'acceptance/acceptance_helper'

feature 'Questions list', %q{
  User can view list of questions
} do

  given(:question_list) { create_list(:question_list, 2) }
  given(:user) { create(:user) }

  scenario 'Authenticated can view list of questions' do
    sign_in(user)

    question_list
    visit questions_path
    expect(page).to have_content question_list.first.title
    expect(page).to have_content question_list.last.title
  end

  scenario 'Non-authenticated user can view list of questions' do
    question_list
    visit questions_path
    expect(page).to have_content question_list.first.title
    expect(page).to have_content question_list.last.title
  end
end
