FactoryBot.define do
  factory :project do
    name { Faker::Lorem.words(number: 2).join(' ') }
    short_description { Faker::Lorem.sentence }
    start_date { Faker::Date.backward(days: 30) }
    end_date { Faker::Date.forward(days: 30) }
    url { Faker::Internet.url }
    repository { Faker::Internet.url }
    favorite { false }

    image do
      Rack::Test::UploadedFile.new(
        Rails.root.join('test/fixtures/files/logo.png').to_s, 'image/png'
      )
    end

    user

    trait :with_skills do
      transient do
        skills_count { 1 }
      end

      after(:build) do |project, evaluator|
        project.skills = FactoryBot.build_list(:project_skill, evaluator.skills_count)
      end
    end
  end
end
