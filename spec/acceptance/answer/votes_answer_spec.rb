require 'acceptance/acceptance_helper'

feature 'Vote for answer', %q{
  User can vote to increase or decrease
  another user's answer rating
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:users_answer) { create(:answer, question: question, user: user) }
  given(:user2) { create(:user) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  context 'Vote up' do

    scenario "authenticated user can vote ", js: true do
      within "#answer-#{answer.id}" do
        click_link 'Vote UP'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario "authenticated user can't vote twice", js: true do
      within "#answer-#{answer.id}" do
        click_link 'Vote UP'
        wait_for_ajax
        click_link 'Vote UP'
        expect(page).to have_content 'Rating: 1'
        expect(page).to have_content "You can vote only once"
      end
    end
  end

  context 'Vote down' do

    scenario "authenticated user can vote down", js: true do
      within "#answer-#{answer.id}" do
        click_link 'Vote DOWN'
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario "authenticated user can't vote twice", js: true do
      within "#answer-#{answer.id}" do
        click_link 'Vote DOWN'
        wait_for_ajax
        click_link 'Vote DOWN'
        expect(page).to have_content 'Rating: -1'
        expect(page).to have_content "You can vote only once"
      end
    end
  end

  context 'Cancel vote' do
    scenario "user can cancel his vote", js: true do

      within "#answer-#{answer.id}" do
        click_link 'Vote UP'
        wait_for_ajax
        click_link 'Cancel'
        wait_for_ajax
        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  scenario "author of the question don't see links for vote", js: true do
    within "#answer-#{users_answer.id}" do
      expect(page).not_to have_content 'Vote UP'
      expect(page).not_to have_content 'Vote DOWN'
      expect(page).not_to have_content 'Cancel'
    end
  end

  fcontext "mulitple sessions" do
    before do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
 
      Capybara.using_session('user2') do
        sign_in(user2)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'new-answer-body', with: 'text text12'
        click_on 'Create answer'
        within '.answers' do
          expect(page).to have_content 'text text12'
        end
      end
    end

    scenario "answer Vote UP link works in another users session", js: true do
      Capybara.using_session('user2') do
        within '.answers' do

          click_link 'Vote UP'
          expect(page).to have_content 'Rating: 1'
        end
      end
    end

    scenario "answer Vote DOWN link works in another users session", js: true do
      Capybara.using_session('user2') do
        within '.answers' do

          click_link 'Vote DOWN'
          expect(page).to have_content 'Rating: -1'
        end
      end
    end

    scenario "answer Cancel vote link works in another users session", js: true do
      Capybara.using_session('user2') do
        within '.answers' do
          click_link 'Vote DOWN'
          click_link 'Cancel'
          expect(page).to have_content 'Rating: 0'                    
        end
      end
    end
  end 
end
