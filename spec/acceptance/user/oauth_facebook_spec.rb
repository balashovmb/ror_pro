require 'acceptance/acceptance_helper'

feature 'Sign is with facebook', '
  To ask questions or answer the questions
  User can login through facebook
' do
  scenario 'User sign in with valid credentials' do
    visit new_user_session_path
    mock_auth_hash('facebook', 'test@test.com')
    click_on 'Sign in'
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
  end

  scenario 'User try to sign in with invalid credentials' do
    visit new_user_session_path
    mock_auth_invalid_hash('facebook')
    click_on 'Sign in'
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Could not authenticate you because invalid credentials'
  end
end
