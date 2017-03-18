require 'acceptance/acceptance_helper'

feature 'Best answer', %q{
  Author of question 
  Can mark answer as best
} do

  given!(:question) {create(:question) }
  given!(:answer) { create(:answer, question: question)}


  context 'Authenticated user' do
    scenario 'user is author of the question', js: true do
      sign_in(question.user)
      visit question_path(question)

      click_on 'Set best'

      within '.best' do
        expect(page).to have_content 'Best answer!' 
      end 
    end
  end
end

