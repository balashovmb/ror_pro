require 'acceptance/acceptance_helper'

feature 'Best answer', %q{
  Author of question 
  Can mark answer as best
} do

  given!(:question) {create(:question) }
  given!(:answer) { create(:answer, question: question)}
 # given!(:answer2) { create(:answer, question: question)}

  context 'Authenticated user' do
    scenario 'user is author of the question', js: true do
      sign_in(question.user)
      visit question_path(question)

      click_link 'Set best'
  
      wait_for_ajax    
     
      save_and_open_page              
    
      expect(page).to have_content 'BEST ANSWER!' 
    end
  end
end

