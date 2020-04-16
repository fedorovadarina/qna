require 'rails_helper'

feature 'user can create answer to the question', %q{
  User must be authenticate,
  Create a new answer to the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create a new answer to the question' do
      text = Faker::Number.hexadecimal(10)
      fill_in 'Your answer', with: text
      click_on 'Create Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer successfully created'
      within '.answers-list' do
        expect(page).to have_content text
      end
    end

    scenario 'create empty answer' do
      click_on 'Create Answer'

      expect(page).to have_content "Please, enter text of answer"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'unAuth user cannot create answer' do
    visit question_path(question)
    fill_in 'Your answer', with: 'just sample text'
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end