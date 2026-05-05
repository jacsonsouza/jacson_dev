FactoryBot.define do
  factory :ahoy_visit, class: 'Ahoy::Visit' do
    visit_token { SecureRandom.uuid }
    visitor_token { SecureRandom.uuid }
    started_at { Time.current }
    ip { '127.0.0.1' }
    user_agent { 'Mozilla/5.0...' }
    landing_page { 'https://exemplo.com' }
  end
end
