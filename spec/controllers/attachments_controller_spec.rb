require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, :with_attachment, author: user) }

  describe 'DELETE attachment' do
    before { login(user) }

    context 'Author delete attached file' do
      it 'deletes the file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Non-author tries to delete attached file' do
      let!(:question_user2) { create(:question, :with_attachment, author: user2) }

      it 'file do not deletes' do
        expect { delete :destroy, params: { id: question_user2.files.first }, format: :js }.to_not change(ActiveStorage::Attachment, :count)
      end

      it 'renders show view' do
        delete :destroy, params: { id: question_user2.files.first }, format: :js
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
