FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    factory :questions_list do
      sequence(:title) { |n| "Question Title #{n}" }
      sequence(:body) { |n| "Question Body #{n}" }
    end
  end
end
