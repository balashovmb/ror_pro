require 'acceptance/acceptance_helper'

feature 'Delete files from answers', %q{
  In order to fix answer
  As an authenticated author 
  Can delete attached files
} do
    given!(:user){ create(:user) }
    given!(:question) {create(:question)}
    given!(:answer) {create(:answer, user: user, question: question)}    
    given!(:file){ create(:attachment, attachable: answer) }
    given!(:another_user){ create(:user) }

  scenario 'Author deletes file from question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_link 'Delete file'
    end  

    expect(page).not_to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'    
  end

  scenario 'Another user dont see Delete file link', js: true do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content 'Delete file'
    end      
  end
end 
