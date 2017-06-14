require 'acceptance/acceptance_helper'

feature 'Vote for question', %q{
  User can vote to increase or decrease
  another user's question rating
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:users_question) { create(:question, user: user) }

  given(:login_and_open_question) do
    sign_in(user)
    visit question_path(question)
  end

  context 'Vote up' do
    before { login_and_open_question }

    scenario "authenticated user can vote ", js: true do
      within ".question" do
        find("[id='vote_up']").click
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario "authenticated user can't vote twice", js: true do
      within ".question" do
        find("[id='vote_up']").click
        wait_for_ajax
        find("[id='vote_up']").click
        expect(page).to have_content 'Rating: 1'
        expect(page).to have_content "You can vote only once"
      end
    end
  end

  context 'Vote down' do
    before { login_and_open_question }

    scenario "authenticated user can vote down", js: true do
      within ".question" do
        find("[id='vote_down']").click
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario "authenticated user can't vote twice", js: true do
      within ".question" do
        find("[id='vote_down']").click
        wait_for_ajax
        find("[id='vote_down']").click
        expect(page).to have_content 'Rating: -1'
        expect(page).to have_content "You can vote only once"
      end
    end
  end

  context 'Cancel vote' do
    scenario "user can cancel his vote", js: true do
      login_and_open_question

      within ".question" do
        find("[id='vote_up']").click
        wait_for_ajax
        find("[id='cancel_vote']").click
        wait_for_ajax
        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  scenario "author of the question don't see links for vote", js: true do
    sign_in(user)
    visit question_path(users_question)

    within ".question" do
      expect(page).not_to have_selector('#vote_up')
      expect(page).not_to have_selector('#vote_down')
      expect(page).not_to have_selector('#cancel_vote')
    end
  end
end