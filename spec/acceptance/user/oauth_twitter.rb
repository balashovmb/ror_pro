require 'acceptance/acceptance_helper'

feature 'Sign in with twitter', '
  To ask questions or answer the questions
  User can login through twitter
' do
  scenario 'User sign in with valid credentials' do
    visit new_user_session_path
    mock_auth_hash('twitter', 'test@test.com')
    click_on 'Sign in'
    click_on 'Sign in with Twitter'
  
    expect(page).to have_content 'Successfully authenticated from Twitter account.'
  end

  scenario 'User try to sign in with valid invalid credentials' do
    visit new_user_session_path
    mock_auth_invalid_hash('twitter')
    click_on 'Sign in'
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Could not authenticate you because invalid credentials'
  end
end
