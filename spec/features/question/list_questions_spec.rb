require 'rails_helper'

feature 'User can view the list of questions', %q{
  As a user
  I can see the list of all questions
  To pick one
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:questions_list, 3, author: user) }

  scenario 'user get list of all questions' do
    visit questions_path

    questions.each do |q|
      expect(page).to have_content q.title
      expect(page).to have_content q.author.email
    end
  end
end