require 'rails_helper'

feature 'user can add comment to question', %q{
  the user can add comment,
  guest can view comments of the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question2) { create(:question) }
  given!(:comment) { create(:comment, commentable: question, author: user) }
  given!(:comments) { create_list(:comments_list, 3, commentable: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can write comment to question with correct data' do
      within '#question' do
        click_on 'Write comment'
        fill_in 'Your comment', with: comment.body
        click_on 'Create Comment'

        within '.comments' do
          expect(page).to have_content comment.body
        end
      end
    end

    scenario 'can NOT write comment to question with invalid data' do
      within '#question' do
        comments_quantity = find('.comments-list').all('.comment-list__item').size

        click_on 'Write comment'
        fill_in 'Your comment', with: ''
        click_on 'Create Comment'

        within '.comments' do
          expect(find('.comments-list').all('.comment-list__item').size).to eq comments_quantity
        end
      end

      expect(page).to have_content "Comment can't be blank"
    end
  end

  describe 'ActionCable multiple sessions', js: true do
    scenario "comment appears on another user's question page" do
      text = Faker::Number.hexadecimal(10)

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('guest2') do
        visit question_path(question2)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within '#question' do
          click_on 'Write comment'
          fill_in 'Your comment', with: text
          click_on 'Create Comment'

          expect(current_path).to eq question_path(question)

          within '.comments-list' do
            expect(page).to have_content text
            expect(page).to have_content text, count: 1
          end
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content text
      end

      Capybara.using_session('guest2') do
        expect(page).to_not have_content text
      end
    end
  end

  describe 'Un-authenticated user' do
    background do
      visit polymorphic_path(comments.first.commentable)
    end

    scenario 'can view comments of question' do
      within '#question .comments' do
        expect(find('.comments-list').all('.comment-list__item').size).to be > 1
      end
    end

    scenario 'can NOT write comment to question', js: true do
      expect('#question').not_to have_link 'Write comment'
    end
  end
end