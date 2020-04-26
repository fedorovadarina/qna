require 'rails_helper'

feature 'User can watch his profile page', %q{
  As an authenticated user
  he can go to his profile page
  to watch personal data
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  background { sign_in(user) }

  scenario 'User tries to get his profile page' do
    visit user_path(user)

    expect(page.find('#profile')).to have_content user.email
  end

  scenario 'User tries to get not his profile page' do
    visit user_path(user2)

    expect(page.find('#profile')).to_not have_content user2.email
  end
end

feature 'User can look at his rewards', %q{
  As an unauthenticated user
  he can go to his profile page
  to watch his rewards
} do

  given(:user) { create(:user, :with_rewards) }
  given(:user2) { create(:user) }

  scenario 'User can look his rewards' do
    sign_in(user)
    visit user_path(user)
    reward = user.rewards.sample

    within('.rewards-list') do
      expect(page).to have_content reward.name
      expect(page).to have_css("img[src*='#{rails_blob_path(reward.image)}']")
      expect(page).to have_content reward.question.title
    end
  end

  scenario 'User tries to get not his rewards' do
    sign_in(user2)
    visit user_path(user)

    reward = user.rewards.sample

    within('.rewards-list') do
      expect(page).to_not have_content reward.name
      expect(page).to_not have_css("img[src*='#{rails_blob_path(reward.image)}']")
      expect(page).to_not have_content reward.question.title
    end
  end
end
