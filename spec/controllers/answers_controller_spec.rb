require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:question_user2) { create(:question, author: user2) }
  let(:answer) { create(:answer, question: question, author: user) }

  it_behaves_like 'voted'

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'new answer belongs to the logged user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }

        expect(assigns(:answer).author).to eq user
      end

      it 'create answer and render question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'Author delete answer' do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render to question page' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Non-author delete answer' do
      let!(:answer_user2) { create(:answer, question: question, author: user2) }

      it 'answer does not deleted' do
        expect { delete :destroy, params: { id: answer_user2 }, format: :js }.to_not change(Answer, :count)
      end

      it 'render to question page' do
        delete :destroy, params: { id: answer_user2 }, format: :js
        
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, author: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'when not an author' do
      let(:user2) { create(:user) }
      let!(:answer_user2) { create(:answer, question: question, author: user2) }

      it 'does not change' do
        patch :update, params: { id: answer_user2, answer: { body: 'new body' } }, format: :js
        answer_user2.reload

        expect(answer_user2.body).to_not eq 'new body'
      end
    end
  end

  describe 'PATCH #best' do
    before { login(user) }

    let!(:answer_for_question_user2) { create(:answer, question: question_user2) }

    context 'User is an author of question' do
      it 'changes best answer attribute' do
        patch :best, params: { id: answer }, format: :js
        answer.reload

        expect(answer.best).to be_truthy
      end

      it 'unselect best answer attribute' do
        patch :best, params: { id: answer }, format: :js
        patch :best, params: { id: answer }, format: :js
        answer.reload

        expect(answer.best).to be_falsey
      end

      it 'renders best view' do
        patch :best, params: { id: answer }, format: :js

        expect(response).to render_template :best
      end
    end

    context 'User is NOT an author of question' do
      it 'tries to change best answer attribute' do
        patch :best, params: { id: answer_for_question_user2 }, format: :js
        answer_for_question_user2.reload

        expect(answer_for_question_user2.best).to be_falsey
      end

      it 'renders best view' do
        patch :best, params: { id: answer_for_question_user2 }, format: :js

        expect(response).to render_template :best
      end
    end
  end
end
