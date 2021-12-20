FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "JohnDow_#{n}" }
    name { "John Dow" }
    url { "http://www.example.com" }
    avatar_url { "http://www.avatar.url" }
    provider { "github" }
  end
end
