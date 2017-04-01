require 'acceptance/acceptance_helper'

feature 'Vote for question', %q{
  User can vote to increase or decrease
  another user's question rating  
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:users_question) { create(:question, user: user) }

  context 'Vote up' do

    scenario "authenticated user can vote to increase question's rating", js: true do
      sign_in(user)
      visit question_path(question)
      
      within ".question" do
        click_link '+'
        expect(page).to have_content 'Rating: 1'      
      end
    end

    scenario "author of the question don't see links for vote", js: true do
      sign_in(user)
      visit question_path(users_question)
      
      within ".question" do
        expect(page).not_to have_content '+'  
      end
    end

    scenario "authenticated user can't vote twice", js: true do
      sign_in(user)
      visit question_path(question)
      
      within ".question" do
        click_link '+'
        click_link '+'      
        expect(page).to have_content 'Rating: 1'      
      end
    end
  end
end