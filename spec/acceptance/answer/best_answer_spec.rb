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

  context 'Author of the question click on Set best link' do
    before do
      sign_in(question.user)
      visit question_path(question)

      within "#answer-#{answer3.id}" do
        click_link 'Set best'
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
      expect(first('.answer')).to have_content 'BEST ANSWER!'
    end
  end

  scenario "non author of question can't see Set best link", js: true do
    sign_in(another_user)
    visit question_path(question)
    expect(page).not_to have_link 'Set best'
  end
end
