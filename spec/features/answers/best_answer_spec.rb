require 'rails_helper'

feature 'User can select best answer', %q{
  for his question user can select one best answer,
  change the mind and select another answer at any time,
  and best answer will be shown at first position
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answers_list, 5, question: question, author: user) }
  given!(:user2) { create(:user) }
  given!(:question2) { create(:question, author: user2) }
  given!(:answers2) { create_list(:answers_list, 3, question: question2, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'select best answer and it shown first' do
      answer = answers.sample
      within "li[data-answer-id='#{answer.id}']" do
        click_on 'Select as best answer'

        expect(first(:xpath, './/..')).to have_css '.best-answer'
      end

      expect(page).to have_css '.best-answer', count: 1
      first_li = first '.answer-list__item'
      best_answer_li = first '.best-answer'

      expect(first_li).to eq best_answer_li
    end

    scenario 'unselect best answer' do
      answer = answers.sample
      within "li[data-answer-id='#{answer.id}']" do
        click_on 'Select as best answer'
        click_on 'Select as best answer'
      end

      expect(page).to_not have_css '.best-answer'
    end

    scenario 'select another best answer and it is only one' do
      answer = answers[2]
      within "li[data-answer-id='#{answer.id}']" do
        click_on 'Select as best answer'

        expect(first(:xpath, './/..')).to have_css '.best-answer'
      end

      another_answer = answers[3]

      within "li[data-answer-id='#{another_answer.id}']" do
        click_on 'Select as best answer'

        expect(first(:xpath, './/..')).to have_css '.best-answer'
      end

      expect(page).to have_css('.best-answer', count: 1)
    end

    scenario "tries to select best answer for other user's question" do
      visit question_path(question2)

      expect(page).to_not have_selector :link_or_button, 'Select as best answer'
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to select best answer' do
      visit question_path(question)

      expect(page).to_not have_selector :link_or_button, 'Select as best answer'
    end
  end
end
