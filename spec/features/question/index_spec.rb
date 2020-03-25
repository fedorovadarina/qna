require 'rails_helper'

feature 'User can view the list of questions', %q{
  As a user
  I can see the list of all questions
  To pick one
} do

  scenario 'view a list of all questions' do
    create(:question, title: 'question1 title', body: 'question1 body')
    create(:question, title: 'question2 title', body: 'question2 body')

    visit questions_path

    expect(page).to have_content 'question1 title'
    expect(page).to have_content 'question1 body'
    expect(page).to have_content 'question2 title'
    expect(page).to have_content 'question2 body'
  end
end
