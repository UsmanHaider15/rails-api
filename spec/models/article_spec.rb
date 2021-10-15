require 'rails_helper'

RSpec.describe Article, type: :model do
  it "test article object" do
    article = create(:article)
    expect(article.title).to eq("Sample Title")
  end
end
