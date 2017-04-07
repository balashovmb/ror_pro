require 'acceptance/acceptance_helper'

feature 'Show answers', %q{
  Any user can see all answers of any question
} do

  given!(:question) { create(:question) }
  given!(:answers) {create_list :answer_list, 2, question: question }

  scenario 'authenticated user can see answers' do
    sign_in(question.user)

    visit question_path(question)

    expect(page).to have_content answers.first.body
    expect(page).to have_content answers.last.body
  end

  scenario 'non-authenticated user can see answers ' do
    visit question_path(question)

    expect(page).to have_content answers.first.body
    expect(page).to have_content answers.last.body
  end
end
