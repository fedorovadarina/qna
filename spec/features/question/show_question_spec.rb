require 'rails_helper'

feature 'User can view the question', %q{
  The user can view the question,
  View the answers to the question,
  Create a new answer to the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  background { visit question_path(question) }

  scenario 'the user can view the question' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end