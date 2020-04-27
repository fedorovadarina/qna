FactoryBot.define do
  factory :reward do
    name { Faker::Superhero.name }
    association :question
    association :user

    before :create do |reward|
      file_path = Rails.root.join('public', 'apple-touch-icon.png')
      file = fixture_file_upload(file_path, 'image/png')
      reward.image.attach(file)
    end
  end
end
