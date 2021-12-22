require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do

  describe "#create" do

    context "when no code provided" do
      subject { post :create }
      it_behaves_like 'authentication_request'
    end
    context "when invalid code code provided" do
      let(:github_error) {
        double("Sawyer::Resource", error: "bad_verification_code")
      }
      before do
          allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(github_error)
      end

      subject { post :create, params: { code: 'invalid_code' } }
      it_behaves_like 'authentication_request'
    end
  
    context "when valid code is provided" do
      let(:user_data) do
        {:login=>"JohnDow_1", :avatar_url=>"http://www.avatar.url", :url=>"https://www.example.com", :name=>"John Dow"}
      end

      before do
          allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return('validtoken')
          allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
      end

      subject { post :create, params: { "code" => "valid_code"} }
      it "should return 201 status code" do
        subject
        expect(response).to have_http_status(201)
      end

      it "should return proper token" do
        expect { subject }.to change{ User.count }.by(1)
        user = User.find_by(login: 'JohnDow_1')
        expect(json_data[:attributes]).to eq({token: user.access_token.token})
      end
    end
  end

  describe "#destroy" do
    subject { post :destroy}

    context "when no Authorization header provided" do
      it_behaves_like "forbidden_request"
    end

    context "when bad Authorization header provided" do
      before { request.headers['authorization'] = "Invalid token"}
      it_behaves_like "forbidden_request"
    end


    context "when valid request" do
      
    end
  end
end
