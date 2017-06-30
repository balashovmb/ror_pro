require 'acceptance/acceptance_helper'

feature 'Search', %q{
  To be able to find information, anyone can use search
} do

  let(:question1) { create(:question, title: 'Founded question 1') }
  let(:answer) { create(:answer, body: 'Founded answer') }

  before do
    create(:comment, commentable: question1, body: 'Founded question comment')
    create(:comment, commentable: answer, body: 'Founded answer comment')
    create(:question, title: 'Founded question 2')
    create(:user, email: 'founded@test.com')
    create(:question, title: 'not_findable')
    index
    visit root_path
  end

  scenario 'Empty query', js: true do
    click_button 'Find'

    expect(page).to have_content('No results')
  end

  scenario 'Search all contexts', js: true do
    fill_in 'query', with: 'Founded'
    click_button 'Find'

    expect(page).to have_content('Founded question 1')
    expect(page).to have_content('Founded question 2')
    expect(page).to have_content('Founded answer')
    expect(page).to have_content('Founded question comment')
    expect(page).to have_content('Founded answer comment')
    expect(page).to have_content('founded@test.com')
    expect(page).not_to have_content('not_findable')
  end

  scenario 'User searches questions', js: true do
    fill_in 'query', with: 'Founded'
    select 'Questions', from: 'object'
    click_button 'Find'

    expect(page).to have_content('Founded question 1')
    expect(page).to have_content('Founded question 2')
  end

  scenario 'User searches answers', js: true do
    fill_in 'query', with: 'Founded'
    select 'Answers', from: 'object'
    click_button 'Find'

    expect(page).to have_content('Founded answer')
  end

  scenario 'User searches comments', js: true do
    fill_in 'query', with: 'Founded'
    select 'Comments', from: 'object'
    click_button 'Find'

    expect(page).to have_content('Founded answer comment')
    expect(page).to have_content('Founded question comment')
  end

  scenario 'User searches users', js: true do
    fill_in 'query', with: 'Founded'
    select 'Users', from: 'object'
    click_button 'Find'

    expect(page).to have_content('founded@test.com')
  end
end
