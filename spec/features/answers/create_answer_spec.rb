require 'rails_helper'

feature 'user can create answer to the question', %q{
  User must be authenticate,
  Create a new answer to the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create a new answer to the question' do
      text = Faker::Number.hexadecimal(10)
      fill_in 'Body', with: text
      click_on 'Create answer'

      expect(page).to have_content 'Answer successfully created'
      expect(page).to have_content text
    end

    scenario 'create empty answer' do
      fill_in 'Body', with: nil
      click_on 'Create answer'

      expect(page).to have_content "Please, enter answer's text"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'unAuth user cannot create answer' do
    visit question_path(question)
    fill_in 'Body', with: 'just sample text'
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end