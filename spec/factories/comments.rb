FactoryBot.define do
  factory :comment do
    body { Faker::Number.hexadecimal(10) }
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end

    factory :comments_list do
      sequence(:body) { |n| "Comment Body #{n} #{Faker::Number.hexadecimal(4)}" }
    end
  end
end
