require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable'

  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:reward) { create(:reward, user: user1) }
  let!(:question) { create(:question, author: user1, reward: reward) }

  it 'set_reward!' do
    question.set_reward!(user2)
    expect(question.reward.user).to eq user2
  end
end
