require 'acceptance/acceptance_helper'

feature 'Best answer', %q{
  Author of question
  Can mark answer as best
} do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question, best: true) }
  given!(:answer3) { create(:answer, question: question) }
  given(:another_user) { create(:user) }

  context 'Author of the question click on Set best button', js: true do
    before do
      sign_in(question.user)
      visit question_path(question)

      within "#answer-#{answer3.id}" do
        click_button 'Set best'
      end
    end

    scenario 'marks answer as best', js: true do
      within "#answer-#{answer3.id}" do
        expect(page).to have_content 'BEST ANSWER!'
      end
    end

    scenario 'mark on previous best answer disappears', js: true do
      within "#answer-#{answer2.id}" do
        expect(page).not_to have_content 'BEST ANSWER!'
      end
    end

    scenario 'best answer shows first in answer list', js: true do
      wait_for_ajax
      expect(first('.answer')).to have_content 'BEST ANSWER!'
    end
  end

  scenario "non author of question can't see Set best", js: true do
    sign_in(another_user)
    visit question_path(question)
    expect(page).not_to have_button 'Set best'
  end

  context "mulitple sessions" do
    before do
      Capybara.using_session('user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user2') do
        sign_in(question.user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'new-answer-body', with: 'text text12'
        click_on 'Create answer'
        wait_for_ajax
        within '#answer-4' do
          expect(page).to have_content 'text text12'
        end
      end
    end

    scenario "answer Set best works in another users session", js: true do
      Capybara.using_session('user2') do
        within '#answer-4' do
          click_link 'Set best'
          expect(page).to have_content 'BEST ANSWER!'
        end
      end
    end
  end
end