require 'acceptance/acceptance_helper'

feature 'Create comment to answer', %q{
 To make the answer more understandable
 authentified user can add comment to this answer
} do

  let(:user) { create(:user) }
  let(:answer) { create(:answer) }

  context 'single session' do
    before do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario 'User adds comment to the answer', js: true do
      within "#answer-#{answer.id}" do
        click_button 'Add comment'
        fill_in 'comment-body', with: 'new comment'
        click_on 'Create comment'
        expect(page).to have_content 'new comment'
      end
    end
    scenario 'User tries to create too short comment', js: true do
      within "#answer-#{answer.id}" do
        click_button 'Add comment'
        fill_in 'comment-body', with: 'lol'
        click_on 'Create comment'
        expect(page).not_to have_content 'lol'
        expect(page).to have_content 'Body is too short'
      end
    end
  end

  context "mulitple sessions" do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(answer.question)
      end

      Capybara.using_session('guest') do
        visit question_path(answer.question)
      end

      Capybara.using_session('user') do
        within "#answer-#{answer.id}" do
          click_button 'Add comment'
          fill_in 'comment-body', with: 'new comment'
          click_on 'Create comment'
          expect(page).to have_content 'new comment'
        end
      end

      Capybara.using_session('guest') do
        within "#answer-#{answer.id}" do
          expect(page).to have_content 'new comment'
        end
      end
    end
  end
end