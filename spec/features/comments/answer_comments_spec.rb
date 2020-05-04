require 'rails_helper'

feature 'user can add comment to answer', %q{
  the user can add comment,
  guest can view comments of the answer
} do

  given(:user) { create(:user) }
  given!(:answer) { create(:answer) }
  given!(:comment) { create(:comment, commentable: answer, author: user) }
  given!(:comments) { create_list(:comments_list, 3, commentable: answer) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit polymorphic_path(answer.question)
    end

    scenario 'can write comment to answer with correct data' do
      first_answer = first('.answer-list__item')
      within first_answer do
        click_on 'Write comment'
        fill_in 'Your comment', with: comment.body
        click_on 'Create Comment'

        within '.comments' do
          expect(page).to have_content comment.body
        end
      end
    end

    scenario 'can NOT write comment to answer with invalid data' do
      first_answer = first('.answer-list__item')
      within first_answer do
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

  describe 'Un-authenticated user' do
    background do
      visit polymorphic_path(comments.first.commentable.question)
    end

    scenario 'can view comments of answer' do
      first_answer = first('.answer-list__item')
      within first_answer do
        expect(find('.comments-list').all('.comment-list__item').size).to be > 1
      end
    end

    scenario 'can NOT write comment to answer', js: true do
      first_answer = first('.answer-list__item')
      within first_answer do
        expect(page).not_to have_link 'Write comment'
      end
    end
  end
end