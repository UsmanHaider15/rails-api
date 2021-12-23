require 'rails_helper'

RSpec.describe "Article Routes" do
    it "GET /articles request routes to articles#index" do
        expect(get '/articles').to route_to("articles#index")
    end

    it "GET /articles/1 request routes to articles#show" do
        expect(get '/articles/1').to route_to("articles#show", id: "1")
    end

    it "POST /articles/1 routes to articles#create" do
        expect(post '/articles').to route_to("articles#create")
    end
end