FactoryBot.define do
  factory :link do
    name { Faker::Internet.slug }
    url { Faker::Internet.url('example.com', "/#{name}") }
    association :linkable, factory: :user
  end
end
