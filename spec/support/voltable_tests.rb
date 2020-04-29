require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { create(described_class.name.downcase.to_sym) }

  it { should have_many(:votes).dependent(:destroy) }

  it 'change rating to plus' do
    expect { model.vote_plus }.to change { model.rating }.by(1)
  end

  it 'change rating to minus' do
    expect { model.vote_minus }.to change { model.rating }.by(-1)
  end
end