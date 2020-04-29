require 'rails_helper'

feature 'User can vote for favorite question/answer', %q{
  User have to be authenticated,
  can vote one time for one item,
  and cannot vote for his question|answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question_user) { create(:question, author: user) }
  given!(:answers) { create_list(:answers_list, 3, question: question, author: user) }

  describe 'User vote for question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'one time up' do
      within('#question > .votes') do
        link_vote_up = first(:xpath, "//a[@title='Vote up!']")
        link_vote_up.click
        sleep 0.5

        expect(first('.vote-rating')).to have_content '1'
        expect(link_vote_up[:class]).to include 'vote-active'
      end
    end

    scenario 'one time down' do
      within('#question > .votes') do
        link_vote_down = first(:xpath, "//a[@title='Vote down!']")
        link_vote_down.click
        sleep 0.5

        expect(first('.vote-rating')).to have_content '-1'
        expect(link_vote_down[:class]).to include 'vote-active'
      end
    end

    scenario 'tries to vote three times up' do
      within('#question > .votes') do
        link_vote_up = first(:xpath, "//a[@title='Vote up!']")
        link_vote_up.click
        link_vote_up.click
        link_vote_up.click
        sleep 0.5

        expect(first('.vote-rating')).to have_content '1'
        expect(link_vote_up[:class]).to include 'vote-active'
      end
    end

    scenario 'tries to vote three times down' do
      within('#question > .votes') do
        link_vote_down = first(:xpath, "//a[@title='Vote down!']")
        link_vote_down.click
        link_vote_down.click
        link_vote_down.click
        sleep 0.5

        expect(first('.vote-rating')).to have_content '-1'
        expect(link_vote_down[:class]).to include 'vote-active'
      end
    end

    scenario 'remove his vote' do
      within('#question > .votes') do
        link_vote_down = first(:xpath, "//a[@title='Vote down!']")
        link_vote_down.click
        link_vote_down.click
        sleep 0.5

        expect(first('.vote-rating')).to have_content '0'
        expect(link_vote_down[:class]).to_not include 'vote-active'
      end
    end

    scenario 'switch vote from up to down' do
      within('#question > .votes') do
        link_vote_up = first(:xpath, "//a[@title='Vote up!']")
        link_vote_down = first(:xpath, "//a[@title='Vote down!']")
        link_vote_up.click
        sleep 0.5
        link_vote_down.click
        sleep 0.5

        expect(first('.vote-rating')).to have_content '-1'
        expect(link_vote_up[:class]).to_not include 'vote-active'
        expect(link_vote_down[:class]).to include 'vote-active'
      end
    end

    scenario 'switch vote from down to up' do
      within('#question > .votes') do
        link_vote_up = first(:xpath, "//a[@title='Vote up!']")
        link_vote_down = first(:xpath, "//a[@title='Vote down!']")
        link_vote_down.click
        sleep 0.5
        link_vote_up.click
        sleep 0.5

        expect(first('.vote-rating')).to have_content '1'
        expect(link_vote_up[:class]).to include 'vote-active'
        expect(link_vote_down[:class]).to_not include 'vote-active'
      end
    end

    scenario 'show user votes on the page' do
      within('#question > .votes') do
        first(:xpath, "//a[@title='Vote up!']").click
        sleep 1
      end

      visit current_path

      within('#question > .votes') do
        link_vote_up = first(:xpath, "//a[@title='Vote up!']")
        link_vote_down = first(:xpath, "//a[@title='Vote down!']")

        expect(first('.vote-rating')).to have_content '1'
        expect(link_vote_up[:class]).to include 'vote-active'
        expect(link_vote_down[:class]).to_not include 'vote-active'
      end
    end

    scenario 'cannot vote for his question' do
      visit question_path(question_user)

      within('#question > .votes') do
        expect(page).to_not have_css '.vote-link'
      end
    end
  end

  describe 'Non-auth user tries to vote', js: true do
    scenario 'but page cannot have links for voting' do
      visit question_path(question)

      expect(page).to_not have_css '.vote-link'
    end
  end
end
