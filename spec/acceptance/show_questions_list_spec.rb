require 'rails_helper'

feature 'Questions list', %q{
  User can view list of questions
} do 
  scenario 'User can view list of questions' do
    
    create_list(:question,2)     

    visit questions_path
    expect(page).to have_content 'Question title1'
    expect(page).to have_content 'Question body1'
    expect(page).to have_content 'Question title2'
    expect(page).to have_content 'Question body2'    
  end

end  