FactoryBot.define do
  factory :skill do
    sequence(:name) { |n| "#{Faker::ProgrammingLanguage.name}-#{n}" }
    category { Faker::Number.between(from: 0, to: 4) }
    short_description { Faker::Lorem.sentence }
    color { Faker::Color.hex_color }
    description { Faker::Lorem.paragraph }
    proficiency { Faker::Number.between(from: 0, to: 100) }
    icon { Rack::Test::UploadedFile.new(Rails.root.join('test/fixtures/files/logo.png').to_s, 'image/png') }

    user

    trait :with_tags do
      transient do
        tags_count { 1 }
      end

      after(:build) do |skill, evaluator|
        skill.tags = build_list(:tag, evaluator.tags_count)
      end
    end
  end
end
