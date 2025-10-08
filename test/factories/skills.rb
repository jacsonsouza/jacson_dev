FactoryBot.define do
  factory :skill do
    name { Faker::ProgrammingLanguage.name }
    description { Faker::Lorem.paragraph }
    proficiency { Faker::Number.between(from: 0, to: 2) }
    icon { Rack::Test::UploadedFile.new(Rails.root.join('test/fixtures/files/logo.png').to_s, 'image/png') }

    tags { [association(:tag)] }

    user
  end
end
