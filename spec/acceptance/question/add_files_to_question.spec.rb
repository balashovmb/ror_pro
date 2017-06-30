require 'acceptance/acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  scenario 'User adds file when asks question', js: true do
    click_on 'Add file'
    attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')

    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User adds several files when asks question', js: true do
    click_on 'Add file'

    attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')

    click_on 'Add file'
    within all('.nested-fields').last do
      attach_file 'File', Rails.root.join('spec', 'rails_helper.rb')
    end

    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end
