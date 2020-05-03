require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  it 'subscribes to stream' do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for('questions')
  end
end