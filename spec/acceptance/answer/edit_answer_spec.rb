require 'acceptance/acceptance_helper'

feature 'Answer editing', %{
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit my answer
} do
  
  given(:answer) { create(:answer) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Edit'    
  end

  describe 'Authenticated user' do

    before do
      sign_in(answer.user)
      visit question_path(answer.question)
    end

    scenario 'author sees link to edit' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'author try to edit his question', js: true  do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea' 
      end

    end

  end

  

  scenario " try to edit other user's question"
end