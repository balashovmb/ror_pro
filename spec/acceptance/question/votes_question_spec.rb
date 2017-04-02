require 'acceptance/acceptance_helper'

feature 'Vote for question', %q{
  User can vote to increase or decrease
  another user's question rating  
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:users_question) { create(:question, user: user) }

  context 'Vote up' do
    before do
      sign_in(user)
      visit question_path(question)
    end    

    scenario "authenticated user can vote ", js: true do
    
      within ".question" do
        click_link 'Vote UP'
        expect(page).to have_content 'Rating: 1'      
      end
    end

    scenario "authenticated user can't vote twice", js: true do
    
      within ".question" do
        click_link 'Vote UP'
        click_link 'Vote UP'      
        expect(page).to have_content 'Rating: 1'      
      end
    end
  end

  context 'Vote down' do
    before do
      sign_in(user)
      visit question_path(question)
    end     

    scenario "authenticated user can vote down", js: true do
      within ".question" do
        click_link 'Vote DOWN'
        expect(page).to have_content 'Rating: -1'      
      end
    end

    scenario "authenticated user can't vote twice", js: true do
      within ".question" do
        click_link 'Vote DOWN'
        click_link 'Vote DOWN'

        expect(page).to have_content 'Rating: -1'      
      end
    end
  end

  context 'Cancel vote' do
     
    scenario "user can cancel his vote up", js: true do
      sign_in(user)
      visit question_path(question)    
      
      within ".question" do
        click_link 'Vote UP'
        click_link 'Cancel'
        expect(page).to have_content 'Rating: 0' 
      end   
    end
  end

  scenario "author of the question don't see links for vote", js: true do
    sign_in(user)      
    visit question_path(users_question)

    within ".question" do
      expect(page).not_to have_content 'Vote UP'
      expect(page).not_to have_content 'Vote DOWN'
      expect(page).not_to have_content 'Cancel'                    
    end
  end
end