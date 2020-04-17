FactoryBot.define do
  factory :question do
    title { "#{Faker::Number.hexadecimal(digits: 4)} question" }
    body { "#{Faker::Number.hexadecimal(digits: 10)}. What is it?" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    factory :questions_list do
      sequence(:title) { |n| "Question Title #{n} #{Faker::Number.hexadecimal(digits: 2)}" }
      sequence(:body) { |n| "Question Body #{n} #{Faker::Number.hexadecimal(digits: 4)}" }
    end
  end
end
