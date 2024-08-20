FactoryBot.define do
  factory :event do
    start_date { Time.current + 1.day }
    end_date { Time.current + 3.days }
    sign_up_start_date { nil  }
    title { 'Absolutely Shag' }
    event_email { nil }
    website { 'https://www.example.com' }
    description { 'example shag weekend in Hamburg' }
    country { 'Germany' }
    city { 'Hamburg' }
    dance_types { ['shag'] }

    trait(:past) do
      start_date { 1.month.ago }
      end_date { 3.weeks.ago }
    end
  end
end
