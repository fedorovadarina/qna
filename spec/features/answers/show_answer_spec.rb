require 'rails_helper'

feature 'Guest can view answers to the question', %q{
  User can be unauthenticate
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answers_list, 3, question: question, author: user) }

  background { visit question_path(question) }

  scenario 'view the answers to the question' do
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end