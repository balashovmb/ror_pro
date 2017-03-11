require 'rails_helper'

feature 'Show question', %q{
  Any user can see question
} do

  given(:question) { create(:question) }

  scenario 'authenticated user can see question' do
    sign_in(question.user)

    visit question_path(question)

    expect(page).to have_content 'Question title'
    expect(page).to have_content 'Question body'
  end

  scenario 'non-authenticated user can see question' do
    visit question_path(question)

    expect(page).to have_content 'Question title'
    expect(page).to have_content 'Question body'
  end
end
