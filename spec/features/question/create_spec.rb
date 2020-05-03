require 'rails_helper'

feature 'User can create question', %q{
  User go to new question form
  Show question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'user create question with correct data' do
      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body
      click_on 'Create Question'

      expect(page).to have_content 'Question successfully created'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'user create question without data' do
      click_on 'Create Question'

      expect(page).to have_content 'Please, enter valid data'
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'ActionCable multiple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit new_question_path

        fill_in 'Title', with: question.title
        fill_in 'Body', with: question.body
        click_on 'Create Question'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end

      Capybara.using_session('guest') do
        expect(page).to have_content question.title
      end
    end
  end

  scenario 'Unauthenticated user cannot ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end