FactoryBot.define do
  factory :message do
    name { 'Jane Doe' }
    body { 'This is some text message.' }
    email { 'foo@example.com' }
    read { false }
  end
end
