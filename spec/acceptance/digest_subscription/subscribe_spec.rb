require 'acceptance/acceptance_helper'

feature 'Unsubscribe from daily digest', %q{
  User can unsubscribe from daily digest
  to stop receiving digest emails
} do

  given(:user) { create(:user) }

  scenario 'User unsubscribes', js: true do
    sign_in(user)
    visit edit_user_registration_path(user)
    click_button('Unsubscribe')
    expect(page).to have_content 'Unsubscribed'
    expect(page).not_to have_content 'Subscribed'
  end
end
