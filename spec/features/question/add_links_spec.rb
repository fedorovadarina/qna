require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:link1) { create(:link) }
  given(:link2) { create(:link) }

  describe 'When create question' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'User add link when create question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: link1.name
      fill_in 'Link URL', with: link1.url

      click_on 'Create Question'

      expect(page).to have_link link1.name, href: link1.url
    end

    scenario 'User adds links when create question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: link1.name
      fill_in 'Link URL', with: link1.url

      click_on 'add link'

      new_link_nested_form = all('.nested-fields').last
      within(new_link_nested_form) do
        fill_in 'Link name', with: link2.name
        fill_in 'Link URL', with: link2.url
      end
      click_on 'Create Question'
      within('.links-list') do
        expect(page).to have_link link1.name, href: link1.url
        expect(page).to have_link link2.name, href: link2.url
      end
    end
  end
end
