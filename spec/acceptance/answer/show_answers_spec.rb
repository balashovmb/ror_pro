require 'acceptance/acceptance_helper'

feature 'Show answers', %q{
  Any user can see all answers of any question
} do

  given!(:question) { create(:question) }
  given!(:answer) {create(:answer, question: question)}
  given!(:answer2) {create(:answer, question: question)}

  scenario 'authenticated user can see answers' do
    sign_in(question.user)

    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to have_content answer2.body
  end

  scenario 'non-authenticated user can see answers ' do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to have_content answer2.body
  end
end
