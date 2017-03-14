require 'acceptance/acceptance_helper'

feature 'Show answers', %q{
  Any user can see all answers of any question
} do

  given(:question) { create(:question) }

  given(:answers) do
    create(:answer, question: question, user: question.user, body: 'Answer body1')
    create(:answer, question: question, user: question.user, body: 'Answer body2')
  end

  scenario 'authenticated user can see answers' do
    answers

    visit question_path(question)

    expect(page).to have_content 'Answer body1'
    expect(page).to have_content 'Answer body2'
  end

  scenario 'non-authenticated user can see answers ' do
    answers

    visit question_path(question)

    expect(page).to have_content 'Answer body1'
    expect(page).to have_content 'Answer body2'
  end
end
