require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:answer_user2) { create(:answer, question: question, author: user2) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      within '.answers-list' do
        click_on 'Edit'
        text = Faker::Number.hexadecimal(10)
        fill_in 'Your answer', with: text
        click_on 'Update Answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content text
        expect(page).to_not have_selector "form#edit-answer-#{answer.id}"
      end
        expect(page).to have_content 'Answer successfully edited'
    end

    scenario 'edits his answer with errors' do
      within '.answers-list' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Update Answer'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'input'
      end
        expect(page).to have_content 'Editing answer failed'
    end

    scenario 'edit by adding attachment' do
      within(all('.answer-list__item').first) do
        click_on 'Edit'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Update Answer'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
      expect(page).to have_content 'Answer successfully edited'
    end

    scenario 'deleting attached files' do
      within(all('.answer-list__item').first) do
        click_on 'Edit'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Update Answer'

        within '.attached-files' do
          first("a[data-method='delete']").click
        end

        page.driver.browser.switch_to.alert.accept

        expect(page).to_not have_link 'rails_helper.rb'
      end
      expect(page).to have_content 'rails_helper.rb successfully deleted'
    end



    scenario "tries to edit other user's question" do
      within page.find('li', text: user2.email) do
        expect(page).to have_no_link 'Edit'
      end
    end
  end
end