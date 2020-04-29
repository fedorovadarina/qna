require 'rails_helper'

RSpec.shared_examples 'voted' do
  let(:user1) { create :user }
  let(:user2) { create :user }
  let!(:model_user1) { create(described_class.controller_name.classify.downcase.to_sym, author: user1) }
  let!(:model_user2) { create(described_class.controller_name.classify.downcase.to_sym, author: user2) }

  describe 'POST #vote_up' do
    before { login(user1) }

    context 'with valid attributes' do
      it 'saves a new vote in the database' do
        expect { post :vote_up, params: { id: model_user2 }, format: :json }.to change(Vote, :count).by(1)
      end

      it 'new vote belongs to the logged user' do
        post :vote_up, params: { id: model_user2 }, format: :json

        expect(Vote.last.user).to eq user1
      end

      it 'render json' do
        post :vote_up, params: { id: model_user2 }, format: :json
        json_response = { "resource" => model_user2.class.name.downcase, "rating" => Vote::RATE[:plus] }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq json_response
      end
    end

    context 'with invalid attributes' do
      it 'not saves vote in the database' do
        expect { post :vote_up, params: { id: model_user1 }, format: :json }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe 'POST #vote_down' do
    before { login(user1) }

    context 'with valid attributes' do
      it 'saves a new vote in the database' do
        expect { post :vote_down, params: { id: model_user2 }, format: :json }.to change(Vote, :count).by(1)
      end

      it 'new vote belongs to the logged user' do
        post :vote_down, params: { id: model_user2 }, format: :json

        expect(Vote.last.user).to eq user1
      end

      it 'render json' do
        post :vote_down, params: { id: model_user2 }, format: :json
        json_response = { "resource" => model_user2.class.name.downcase, "rating" => Vote::RATE[:minus] }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq json_response
      end
    end

    context 'with invalid attributes' do
      it 'not saves vote in the database' do
        expect { post :vote_down, params: { id: model_user1 }, format: :json }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
