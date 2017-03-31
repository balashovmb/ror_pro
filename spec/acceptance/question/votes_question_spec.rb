require 'acceptance/acceptance_helper'

feature 'Vote for question', %q{
  User can vote to increase or decrease
  another user's question rating  
} do
  given!(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario "authenticated user can vote to increase question's rating" do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content '+'
  end
end