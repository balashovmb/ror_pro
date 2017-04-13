require 'acceptance/acceptance_helper'

feature 'Create comment to question', %q{
 To make the question more understandable
 authentified user can add comment to the question
} do

  let(:user) {create(:user)}
  let(:question) {create(:question)}

  scenario 'User adds comment to the question', js: true do
    sign_in(user)
    visit question_path(question)

    click_link 'Comment question'
  end
end