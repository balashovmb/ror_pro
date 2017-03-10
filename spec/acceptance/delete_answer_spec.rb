require 'rails_helper'

feature 'Delete answer', %q{
  Authenticated author of the answer can
  delete it 
} do
  given(:question) { create(:question)}


  scenario 'Authenticated user delete his answer' do
    sign_in(question.user)

    visit question_path(question)
    click_on 'Delete answer'


    expect(page).to have_content "Your answer deleted."
    expect(page).not_to have_content(question.body)      
  end 

end