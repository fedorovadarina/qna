require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :links }
  it { should have_db_column(:best).of_type(:boolean) }
  it { should validate_numericality_of(:rating).only_integer }

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:answers) { create_list(:answer, 3, question: question) }

  let!(:question_reward) { create(:question, :with_reward) }
  let!(:answers_reward) { create_list(:answer, 3, question: question_reward) }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end

  describe 'set best attribute' do
    it 'to true' do
      answer.set_best!

      expect(answer.best).to be_truthy
    end

    it 'back to false' do
      answer.set_best!
      answer.set_best!

      expect(answer.best).to be_falsey
    end

    it 'only one answer can be best' do
      question.answers.each(&:set_best!)

      expect(question.answers.where(best: true).count).to eq 1
    end

    it 'set question reward for best answer author' do
      ans = answers_reward.sample
      ans.set_best!

      expect(question_reward.reward.user).to eq ans.author
    end
  end

  describe 'best answer is first' do
    it 'sort to first' do
      answer = answers.sample
      answer.set_best!
      sorted_answers = answer.question.answers.best_first

      expect(sorted_answers.first).to eq answer
    end
  end
end
