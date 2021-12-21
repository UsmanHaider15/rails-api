require 'rails_helper'

RSpec.describe UserAuthenticator do
    describe "#perform" do
        let(:user_authenitcator) { described_class.new('code') }
        subject {user_authenitcator.perform}

        context "when code is invalid" do
            let(:error_object) {
                double("Sawyer::Resource", error: "bad_verification_code")
            }
            before do
                allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(error_object)
            end

            it "should raise an error" do
                expect{ subject }.to raise_error(UserAuthenticator::AuthenticationError)
                expect(user_authenitcator.user).to be_nil
            end
        end

        context "when code is valid" do
            let(:user_data) do
                {:login=>"JohnDow_1", :avatar_url=>"http://www.avatar.url", :url=>"https://www.example.com", :name=>"John Dow"}
            end

            before do
                allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return('validtoken')
                allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
            end

            it "should create new user if user doesn't exits" do
                expect{ subject }.to change{ User.count }.from(0).to(1)
                expect(User.last.name).to eq("John Dow")
            end

            it "should reuse user if user exists" do
                user = create :user, user_data
                expect{ subject }.not_to change{ User.count }
                expect(user_authenitcator.user).to eq(user)
            end

            it "should create new access token" do
                expect{ subject }.to change{ AccessToken.count }.by(1)
                expect(user_authenitcator.access_token).to be_present
            end
        end
    end
end