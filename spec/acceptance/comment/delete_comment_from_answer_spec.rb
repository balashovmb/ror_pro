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
    click_link 'Delete comment'
    wait_for_ajax
    expect(page).not_to have_content comment.body
  end

  scenario "not an author of the comment don't see Delete comment link", js: true do
    sign_in(user2)
    visit question_path(answer.question)   
    expect(page).not_to have_link 'Delete comment'
  end  
end