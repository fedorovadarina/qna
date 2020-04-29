require 'rails_helper'

feature 'User can vote for favorite question/answer', %q{
  User have to be authenticated,
  can vote one time for one item,
  and cannot vote for his question|answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answers_list, 3, question: question, author: user) }

  describe 'User vote for question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'one time up' do
      first(:xpath, "//a[@title='Vote up!']").click

      expect(first('.vote-rating')).to have_content '1'
    end

    scenario 'one time down' do
      first(:xpath, "//a[@title='Vote down!']").click

      expect(first('.vote-rating')).to have_content '-1'
    end

    scenario 'tries to vote second time up'
    scenario 'tries to vote second time down'
    scenario 'remove his vote'
    scenario 'tries to vote his answer'
  end

  describe 'Non-auth user tries to vote', js: true do
    scenario 'but page cannot have links for voting' do
      visit question_path(question)

      expect(page).to_not have_css '.vote-link'
    end
  end
end
