require 'acceptance/acceptance_helper'

feature 'Create answer', %q{
  In order to help somebody who asked the question
  As an authenticated user
  I want to be able to give answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'new-answer-body', with: 'text text12'
    click_on 'Create answer'
    wait_for_ajax
    within '.answers' do
      expect(page).to have_content 'text text12'
    end
  end

  scenario 'Non-authenticated user can not see Create answer button' do
    visit question_path(question)
    expect(page).not_to have_button('Create answer')
  end

  scenario 'User try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Create answer'

    expect(page).to have_content "Body is too short"
  end

  context "mulitple sessions" do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'new-answer-body', with: 'text text12'
        click_on 'Create answer'
        within '.answers' do
          expect(page).to have_content 'text text12'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text12'
      end
    end
  end
end
