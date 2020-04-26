FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { '12345678' }
    password_confirmation { '12345678' }

    trait :with_rewards do
      rewards { create_list(:reward, 3) }
    end
  end
end
