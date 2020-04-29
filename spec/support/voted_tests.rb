require 'rails_helper'

RSpec.shared_examples 'voted' do
  let(:user) { create :user }
  let(:user2) { create :user }
  let!(:model) { create(described_class.controller_name.classify.downcase.to_sym, author: user) }
  let(:model_invalid) { create(described_class.controller_name.classify.downcase.to_sym, :invalid) }
  let!(:model_user2) { create(described_class.controller_name.classify.downcase.to_sym, author: user2) }

  describe 'POST #vote_up' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new vote in the database' do
        expect { post :vote_up, params: { id: model }, format: :json }.to change(Vote, :count).by(1)
      end

      it 'new vote belongs to the logged user' do
        post :vote_up, params: { id: model }, format: :json

        expect(Vote.last.user).to eq user
      end

      it 'render json' do
        post :vote_up, params: { id: model }, format: :json
        json_response = { "resource" => model.class.name.downcase, "rating" => 1 }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq json_response
      end
    end
  end
end
