require 'rails_helper'

RSpec.describe "Article Routes" do
    it "GET /articles request routes to articles#index" do
        expect(get '/articles').to route_to("articles#index")
    end

    it "GET /articles/1 request routes to articles#show" do
        expect(get '/articles/1').to route_to("articles#show", id: "1")
    end

    it "POST /articles routes to articles#create" do
        expect(post '/articles').to route_to("articles#create")
    end

    it "POST /articles/:id routes to articles#update" do
        expect(patch '/articles/1').to route_to("articles#update", id: '1')
        expect(put '/articles/1').to route_to("articles#update", id: '1')
    end
end