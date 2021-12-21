require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  context "#validations" do
    it "should have valid factory" do
      access_token = create :access_token
      expect(access_token).to be_valid

      another_access_token = build :access_token
      expect(another_access_token).to be_valid

    end

    it "validates presense of token" do
      access_token = build :access_token, token: nil
      expect(access_token).not_to be_valid
    end

    it "validates uniqueness of token" do
      acess_token = create(:access_token)
      expect(acess_token).to be_valid
      another_access_token = build(:access_token, token: acess_token.token)
      expect(another_access_token).not_to be_valid
      expect(another_access_token.errors[:token]).to eq(["has already been taken"])
    end
  end

  context "#initialize" do
    it "should create new access_token on initialize" do
      expect(AccessToken.new.token).to be_present
    end

    it "should generate new access token" do
      user = create :user
      expect{ user.create_access_token }.to change{ AccessToken.count }.by(1)
    end
  end
end
