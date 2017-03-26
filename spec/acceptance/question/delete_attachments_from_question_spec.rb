require 'acceptance/acceptance_helper'

feature 'Delete files from questions', %q{
  In order to fix question
  As an authenticated author 
  Can delete attached files
} do
    given!(:user){ create(:user) }
    given!(:question) {create(:question, user: user)}
    given!(:file){ create(:attachment, attachable: question) }
    given!(:another_user){ create(:user) }

  scenario 'Author deletes file from question', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete file'

    expect(page).not_to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'    
  end

  scenario 'Another user dont see Delete file link', js: true do
    sign_in(another_user)
    visit question_path(question)

    expect(page).not_to have_content 'Delete file'
  end
end          