FactoryBot.define do
  factory :answer do
    body { Faker::Number.hexadecimal(digits: 10) }
    association :question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end

    factory :answers_list do
      sequence(:body) { |n| "Answer Body #{n} #{Faker::Number.hexadecimal(digits: 4)}" }
    end
  end
end
