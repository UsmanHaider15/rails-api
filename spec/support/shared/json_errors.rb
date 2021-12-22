require 'rails_helper'

shared_examples_for "authentication_request" do
    let(:authentication_request_error) do { 
          "status": "401",
          "source": { "pointer": "/code" },
          "title":  "Invalid Code Attribute",
          "detail": "You provided invalid code attribute."
        }          
    end

    it "should return 401 status code" do
      subject
      expect(response).to have_http_status(401)
    end

    it "should return proper error response" do
      subject
      expect(json[:errors]).to include(authentication_request_error)
    end
    
end

shared_examples_for "forbidden_request" do
    let(:authorization_request_error) do { 
          "status": "403",
          "source": { "pointer": "/header/authorization" },
          "title":  "Invalid header authorization",
          "detail": "You provided invalid header authorization."
        }          
    end

    it "should return 401 status code" do
      subject
      expect(response).to have_http_status(401)
    end

    it "should return proper error response" do
      subject
      expect(json[:errors]).to include(authorization_request_error)
    end
    
end