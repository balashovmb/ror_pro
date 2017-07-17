require 'acceptance/acceptance_helper'

feature 'Delete comment from answer', %q{
  User can delete his wrong comment
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:answer) { create(:answer, user: user) }
  given!(:comment) { create(:comment, commentable: answer, user: user) }

  scenario "authenticated user removes his comment from answer", js: true do
    sign_in(user)
    visit question_path(answer.question)
    click_button 'Delete comment'
    wait_for_ajax
    expect(page).not_to have_content comment.body
  end

  scenario "not an author of the comment don't see Delete comment link", js: true do
    sign_in(user2)
    visit question_path(answer.question)
    expect(page).not_to have_link 'Delete comment'
  end
  context "mulitple sessions" do
    scenario "comment disappears on another user's page", js: true do
      Capybara.using_session('guest') do
        visit question_path(answer.question)
        expect(page).to have_content(comment.body)
      end

      Capybara.using_session('user') do
        sign_in(answer.user)
        visit question_path(comment.commentable.question)
        click_on 'Delete comment'
      end

      Capybara.using_session('guest') do
        expect(page).not_to have_content(comment.body)
      end
    end
  end
end
