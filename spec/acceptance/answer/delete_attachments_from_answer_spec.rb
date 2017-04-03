require 'acceptance/acceptance_helper'

feature 'Delete files from answers', %q{
  In order to fix answer
  As an authenticated author
  Can delete attached files
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:attachment) { create(:attachment, attachable: answer) }
  given(:attachment2) { create(:attachment, attachable: answer) }
  given!(:another_user) { create(:user) }

  scenario 'Author deletes file from answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_link 'Delete file'
      expect(page).not_to have_link attachment.file.identifier, href: attachment.file.url
    end
  end

  scenario "Author deletes several files from answer", js: true do
    attachment2
    sign_in(user)
    visit question_path(question)
    within(".answers") do
      click_on("Delete file", match: :first)
      click_on("Delete file")

      expect(page).not_to have_link attachment.file.identifier, href: attachment.file.url
      expect(page).not_to have_link attachment2.file.identifier, href: attachment2.file.url
    end
  end

  scenario 'Another user dont see Delete file link', js: true do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content 'Delete file'
    end
  end
end
