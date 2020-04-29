FactoryBot.define do
  factory :vote do
    value { 1 }
    association :user
  end
end
