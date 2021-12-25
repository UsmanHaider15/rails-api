FactoryBot.define do
  factory :article do
    title { "Sample Title" }
    content { "Sample Content" }
    slug { "unique_slug_#{Time.now.to_f}" }
    association :user
  end
end
