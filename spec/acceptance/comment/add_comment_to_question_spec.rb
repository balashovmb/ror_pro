require 'acceptance/acceptance_helper'

feature 'Create comment to question', %q{
 To make the question more understandable
 authentified user can add comment to the question
} do

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  context 'single session' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User adds comment to the question', js: true do
      within '.question' do
        click_link 'Add comment'
        fill_in 'comment', with: 'new comment'
        click_on 'Create comment'
        expect(page).to have_content 'new comment'
      end
    end
    scenario 'User tries to create too short comment', js: true do
      within '.question' do
        click_link 'Add comment'
        fill_in 'comment', with: 'lol'
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
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          click_link 'Add comment'
          fill_in 'comment', with: 'new comment'
          click_on 'Create comment'
          expect(page).to have_content 'new comment'
        end
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to have_content 'new comment'
        end
      end
    end
  end
end
