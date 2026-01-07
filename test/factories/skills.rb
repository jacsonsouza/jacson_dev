FactoryBot.define do
  factory :skill do
    name { Faker::ProgrammingLanguage.name }
    short_description { Faker::Lorem.sentence }
    color { Faker::Color.hex_color }
    description { Faker::Lorem.paragraph }
    proficiency { Faker::Number.between(from: 0, to: 100) }
    icon { Rack::Test::UploadedFile.new(Rails.root.join('test/fixtures/files/logo.png').to_s, 'image/png') }

    tags { [association(:tag)] }

    user
  end
end
