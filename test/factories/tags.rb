FactoryBot.define do
  factory :tag do
    name { Faker::Job.key_skill }
  end
end
