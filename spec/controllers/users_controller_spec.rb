require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    before { login(user) }
    before { get :show, params: { id: user } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
end
