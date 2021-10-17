require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#validation" do

    it "factory should be valid" do
      user = build :user
      expect(user).to be_valid
    end

    it "should check the presence of attributes" do
      user = build :user, login: nil, provider: nil

      aggregate_failures do
        
        expect(user).not_to be_valid
        expect(user.errors.messages[:login]).to include("can't be blank")
        expect(user.errors.messages[:provider]).to include("can't be blank")
      end
    end

    it "should check the uniqueness of login attribute" do
      user = create :user
      other_user = build :user, login: user.login

      expect(other_user).not_to be_valid

      other_user.login = 'new login'
      expect(other_user).to be_valid
    end
  end
end
