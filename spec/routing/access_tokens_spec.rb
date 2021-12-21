require 'rails_helper'

describe "/login route" do
    it "routes to access_tokens#create" do
        expect(post '/login').to route_to("access_tokens#create")
    end
end