require 'acceptance/acceptance_helper'

feature 'Subscribe to daily digest', %q{
  User can subscribe to daily digest
  to receiving digest emails
} do

  given(:user) { create(:user, digest_subscription: false) }

  scenario 'User subscribes', js: true do
    sign_in(user)
    visit edit_user_registration_path(user)
    click_button('Subscribe')
    expect(page).to have_content 'Subscribed'
    expect(page).not_to have_content 'Unsubscribed'
  end
end
