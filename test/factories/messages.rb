FactoryBot.define do
  factory :message do
    identity { Faker::Name.name }
    email { Faker::Internet.email }
    subject { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
  end
end
