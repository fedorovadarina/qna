require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  RSpec.shared_examples "has comments" do
    let(:user) { create(:user) }
    let!(:comment) { create(:comment, commentable: commentable, author: user) }
    let!(:commentable_classname) { comment.commentable.class.name.downcase }

    describe 'POST #create' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new comment to the database' do
          expect do
            post :create,
                 format: :json,
                 params: { comment: attributes_for(:comment),
                           commentable: commentable_classname,
                           "#{commentable_classname}_id" => comment.commentable.id }
          end.to change(commentable.comments, :count).by(1)
        end

        it 'new comment belongs to the logged user' do
          post :create,
               format: :json,
               params: { comment: attributes_for(:comment),
                         commentable: commentable_classname,
                         "#{commentable_classname}_id" => comment.commentable.id }

          expect(assigns(:comment).author).to eq user
        end

        it 'render comment json' do
          comment_attrs = attributes_for(:comment)

          post :create,
               format: :json,
               params: { comment: comment_attrs,
                         commentable: commentable_classname,
                         "#{commentable_classname}_id" => comment.commentable.id }

          comment_json_ok = {
              resource: commentable_classname,
              resource_id: comment.commentable.id,
              author: comment.author.email,
              id: comment.id + 1,
              updated_at: comment.updated_at.to_datetime.to_formatted_s(:db),
              body: comment_attrs[:body]
          }.to_json

          expect(JSON.parse(response.body)).to include_json JSON.parse(comment_json_ok)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect do
            post :create,
                 format: :json,
                 params: { comment: attributes_for(:comment, :invalid),
                           commentable: commentable_classname,
                           "#{commentable_classname}_id" => comment.commentable.id }
          end.to_not change(commentable.comments, :count)
        end

        it 'got status 422' do
          post :create,
               format: :json,
               params: { comment: attributes_for(:comment, :invalid),
                         commentable: commentable_classname,
                         "#{commentable_classname}_id" => comment.commentable.id }

          expect(response.status).to eq 422
        end
      end
    end
  end

  context "Questions" do
    include_examples "has comments" do
      let(:commentable) { create(:question, author: user) }
    end
  end

  context "Answers" do
    include_examples "has comments" do
      let(:commentable) { create(:answer, author: user) }
    end
  end
end