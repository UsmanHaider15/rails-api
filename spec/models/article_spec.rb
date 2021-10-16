require 'rails_helper'

RSpec.describe Article, type: :model do

  describe "#validation" do
    let(:article) { build(:article) }
    it "tests that factory is valid" do
      expect(article).to be_valid
    end
  
    it "has an invalid title" do
      article.title = ''
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it "has an invalid content" do
      article.content = ''
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end

    it "has an invalid slug" do
      article.slug = ''
      expect(article).not_to be_valid
      expect(article.errors[:slug]).to include("can't be blank")
    end

    it "validates uniqueness of slug" do
      article1 = create(:article)
      expect(article1).to be_valid
      article2 = build(:article, slug: article1.slug)
      expect(article2).not_to be_valid
      expect(article2.errors[:slug]).to eq(["has already been taken"])
    end
  end

  describe ".recent" do
    it "should return recent article first" do
      recent_article = create :article
      older_article = create :article, created_at: 1.hour.ago
  
      expect(described_class.recent).to eq([recent_article, older_article])

      recent_article.update_column(:created_at, 2.hour.ago)
      expect(described_class.recent).to eq([older_article, recent_article])

    end
  end
end
