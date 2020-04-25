require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:link1) { create(:link) }
  given(:link2) { create(:link) }
  given!(:answers) { create_list(:answers_list, 3, question: question, author: user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  
  background do
    sign_in(user)

    visit question_path(question)
  end

  describe 'When create answer', js: true do
    scenario 'User add some links' do
      within('#answer-form') do
        fill_in 'Your answer', with: 'My answer'

        fill_in 'Link name', with: link1.name
        fill_in 'Link URL', with: link1.url

        click_on 'add link'

        new_link_nested_form = all('.nested-fields').last

        within(new_link_nested_form) do
          fill_in 'Link name', with: link2.name
          fill_in 'Link URL', with: link2.url
        end

        click_on 'Create Answer'
      end

      within '.answers-list' do
        expect(page).to have_link link1.name, href: link1.url
        expect(page).to have_link link2.name, href: link2.url
      end
    end

    scenario 'user add gist link' do
      within('#answer-form') do
        fill_in 'Your answer', with: 'My answer'

        fill_in 'Link name', with: 'Gist link'
        fill_in 'Link URL', with: gist_url

        click_on 'Create Answer'
      end

      within '.answers-list' do
        expect(page).to have_link 'Gist link', href: gist_url
        expect(page).to have_content "puts 'Hello, world!"
      end
    end
  end

  describe 'When edit answer', js: true do
    scenario 'user add links' do
      within '.answers-list' do
        first(:link, 'Edit').click

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

        click_on 'Update Answer'

        within('.links-list') do
          expect(page).to have_link link1.name, href: link1.url
          expect(page).to have_link link2.name, href: link2.url
        end
      end
    end

    scenario 'user deletes one link'
    scenario 'user deletes all links'
  end
end
