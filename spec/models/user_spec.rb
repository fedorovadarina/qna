require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }

  it { should validate_presence_of(:email) }

  describe 'user is an author of' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, author: user) }

    it 'his question and answer' do
      expect(user).to be_author_of(question)
    end

    it 'not his question and answer' do
      expect(user2).to_not be_author_of(question)
    end
  end
end
