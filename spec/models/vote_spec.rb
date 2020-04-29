require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_array(Vote::RATE.values) }
  it { should validate_inclusion_of(:votable_type).in_array(%w[Question Answer]) }

  let!(:user1) { create(:user) }
  let!(:question) { create(:question) }
  let(:vote) { create(:vote, votable: question, user: user1) }

  it 'change vote value to minus' do
    expect { vote.vote_minus }.to change { vote.value }.by(-2)
  end
end
