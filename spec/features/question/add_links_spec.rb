require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:link1) { create(:link) }
  given(:link2) { create(:link) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given!(:regular_link) { question.links.create!(name: 'Regular link', url: 'http://ya.ru') }

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

    scenario 'tries to add invalid link' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'Link name'
      fill_in 'Link URL', with: 'invalid.url'

      click_on 'Create Question'

      expect(page).to_not have_link 'Link name', href: 'invalid.url'
      expect(page).to have_content 'url is invalid'

    end

    scenario 'user add gist links' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'Gist link'
      fill_in 'Link URL', with: gist_url

      click_on 'Create Question'

      expect(page).to have_link 'Gist link', href: gist_url
      expect(page).to have_content "puts 'Hello, world!"
    end
  end

  describe 'When edit question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'user adds some links' do
      within('#question') do
        first(:link, 'add link').click

        new_link_nested_form = all('.nested-fields').last
        within(new_link_nested_form) do
          fill_in 'Link name', with: link1.name
          fill_in 'Link URL', with: link1.url
        end

        first(:link, 'add link').click

        new_link_nested_form = all('.nested-fields').last
        within(new_link_nested_form) do
          fill_in 'Link name', with: link2.name
          fill_in 'Link URL', with: link2.url
        end

        click_on 'Update Question'

        within('.links-list') do
          expect(page).to have_link link1.name, href: link1.url
          expect(page).to have_link link2.name, href: link2.url
        end
      end
    end

    scenario 'user deletes link' do
      within('#question') do
        click_on 'remove link'
        click_on 'Update Question'

        expect(page).to_not have_link regular_link.name, href: regular_link.url
      end
    end
  end
end
