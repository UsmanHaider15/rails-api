require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do

  describe "#create" do
    let(:error) do { 
          "status": "401",
          "source": { "pointer": "/code" },
          "title":  "Invalid Code Attribute",
          "detail": "You provided invalid code attribute."
        }          
    end

    context "when invalid code is provided" do
      it "should return 401 status code" do
        post :create
        expect(response).to have_http_status(401)
        
      end

      it "should return proper error response" do
        post :create
        expect(json[:errors]).to include(error)
      end
    end
  
    # context "when valid code is provided" do
      
    # end
  end
end
