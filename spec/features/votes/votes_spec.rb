require 'rails_helper'

feature 'User can vote for favorite question/answer', %q{
  User have to be authenticated,
  can vote one time for one item,
  and cannot vote for his question|answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answers_list, 3, question: question, author: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  describe 'User vote for answer', js: true do
    scenario 'one time up'
    scenario 'one time down'
    scenario 'tries to vote second time up'
    scenario 'tries to vote second time down'
    scenario 'remove his vote'
    scenario 'tries to vote his answer'
  end

  describe 'User vote for question', js: true do
    scenario 'one time up'
    scenario 'one time down'
    scenario 'tries to vote second time up'
    scenario 'tries to vote second time down'
    scenario 'remove his vote'
    scenario 'tries to vote his answer'
  end
end