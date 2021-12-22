require 'rails_helper'

describe "AccessToken" do
    it "/login should routes to access_tokens#create" do
        expect(post '/login').to route_to("access_tokens#create")
    end

    it "/logout should routes to access_tokens#destroy" do
        expect(post '/logout').to route_to("access_tokens#destroy")
    end

end