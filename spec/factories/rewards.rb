FactoryBot.define do
  factory :reward do
    name { "MyString" }
    association :question
    association :user
  end
end
