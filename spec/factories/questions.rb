FactoryBot.define do
  factory :question do
    title { "#{Faker::Number.hexadecimal(digits: 4)} question" }
    body { "#{Faker::Number.hexadecimal(digits: 10)}. What is it?" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_attachment do
      after :create do |question|
        file_path = Rails.root.join('public', 'apple-touch-icon.png')
        file = fixture_file_upload(file_path, 'image/png')
        question.files.attach(file)
      end
    end

    trait :with_reward do
      reward { create(:reward) }
    end

    factory :questions_list do
      sequence(:title) { |n| "Question Title #{n} #{Faker::Number.hexadecimal(digits: 2)}" }
      sequence(:body) { |n| "Question Body #{n} #{Faker::Number.hexadecimal(digits: 4)}" }
    end
  end
end
