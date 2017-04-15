require 'acceptance/acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user2) { create(:user) }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'new-answer-body', with: 'My answer1'
  end

  scenario 'User adds file to answer', js: true do
    click_on 'Add file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds several files to answer', js: true do
    click_on 'Add file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add file'
    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create answer'
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end

 fcontext "mulitple sessions" do
    before do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('user2') do
        sign_in(user2)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'new-answer-body', with: 'text text12'
        click_on 'Add file'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Create answer'
        within '.answers' do
          expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        end
      end
    end

    scenario "answer attachments appears in another users session", js: true do
      Capybara.using_session('user2') do
        within '.answers' do
          expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        end
      end
    end
  end
end
