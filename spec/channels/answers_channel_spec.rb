require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  let(:question_id) { 42 }

  it 'rejects when no question id' do
    subscribe
    perform :follow, question_id: nil

    expect(subscription).to be_rejected
  end

  it "subscribes to a stream when question id is provided" do
    subscribe
    perform :follow, question_id: question_id

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("question#{question_id}:answers")
  end
end