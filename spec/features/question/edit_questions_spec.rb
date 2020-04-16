require 'rails_helper'

feature 'User can edit his question', %q{
  User must be logged in
  Edit question via ajax
  Show question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'edit question' do
      new_title = Faker::Number.hexadecimal(10)
      new_body = Faker::Number.hexadecimal(15)
      fill_in 'Title', with: new_title
      fill_in 'Body', with: new_body
      click_on 'Update Question'

      expect(page).to have_content new_title
      expect(page).to have_content new_body
      expect(page).to have_content 'Question successfully edited'
    end

    scenario 'edit question with invalid data' do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Update Question'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content 'Question editing failed'
    end

    scenario 'submit question with no changes' do
      click_on 'Update Question'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'Unauthenticated user cannot edit a question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end