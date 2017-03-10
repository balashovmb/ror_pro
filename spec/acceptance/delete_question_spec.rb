require 'rails_helper'

feature 'Delete question', %q{
  Authenticated author of the question can
  delete it 
} do
  given(:question) { create(:question)} 

  scenario 'Authenticated user delete his question' do
    sign_in(question.user)

    visit question_path(question)
    click_on 'Delete question'


    expect(page).to have_content "Your question deleted."
    expect(page).not_to have_content(question.body)      
  end 

end