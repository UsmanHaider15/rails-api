FactoryBot.define do
  factory :access_token do
    sequence(:token) { |n| "token#{n}" }
    association :user
  end
end
