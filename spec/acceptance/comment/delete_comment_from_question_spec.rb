require 'acceptance/acceptance_helper'

feature 'Delete comment from question', %q{
  User can delete his wrong comment
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:comment) { create(:comment, commentable: question, user: user) }

  scenario "authenticated user removes his comment from question", js: true do
    sign_in(user)
    visit question_path(question)
    click_link 'Delete comment'
    expect(page).not_to have_content comment.body
  end

  scenario "not an author of the comment don't see Delete comment link", js: true do
    sign_in(user2)
    visit question_path(question)
    expect(page).not_to have_link 'Delete comment'
  end
end
