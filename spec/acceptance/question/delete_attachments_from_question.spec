require 'acceptance/acceptance_helper'

feature 'Delete files from questions', %q{
  In order to fix question
  As an authenticated author 
  Can delete files attached to question 
} do
    given!(:user){ create(:user) }
    given!(:question) {create(:question, user: user)}
    given!(:file){ create(:attachment, attachable: question) }
    given!(:another_user){ create(:user) }

  scenario 'Author deletes file from question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete file'
  end
end          