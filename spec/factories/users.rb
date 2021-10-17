FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "MyString_#{n}" }
    name { "MyString" }
    url { "MyString" }
    avatar_url { "MyString" }
    provider { "MyString" }
  end
end
