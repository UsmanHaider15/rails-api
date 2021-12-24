require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
    describe "#index" do
        it "should return 200 status code" do
            get :index
            expect(response).to have_http_status(:ok)
        end

        it "should return proper json response" do
            article = create(:article)
            get :index
            expect(json_data.length).to eq(1)
            expected = json_data.first

            aggregate_failures do
                expect(expected[:id]).to eq(article.id.to_s)
                expect(expected[:type]).to eq('article')
                expect(expected[:attributes]).to eq({
                    title: article.title,
                    content: article.content,
                    slug: article.slug  
                })
            end
        end

        it "should return articles in descending order" do
            older_article = create :article, created_at: 1.hour.ago
            recent_article = create :article

            get :index
            ids = json_data.map { |item| item[:id].to_i}
            expect(ids).to eq([recent_article.id, older_article.id])
        end

        it "should return paginated response" do
            article1, article2, article3 = create_list(:article, 3)
            get :index, params:{ page: {number: 2, size: 1}}
            expect(json_data.length).to eq(1)
            expect(json_data.first[:id]).to eq(article2.id.to_s)
        end

        it "response have pagination links" do
            article1, article2, article3 = create_list(:article, 3)
            get :index, params:{ page: {number: 2, size: 1}}
            expect(json[:links].length).to eq(5)
            expect(json[:links].keys).to contain_exactly(:first, :prev, :next, :last, :self)
        end
    end

    describe "#show" do
        let(:article) { create :article }
        subject {get :show, :params => { :id => article.id }}
        before { subject }

        it "should return proper status code" do
            expect(response).to have_http_status(:ok)
        end

        it "should return proper json response" do
            aggregate_failures do
                expect(json_data[:id]).to eq(article.id.to_s)
                expect(json_data[:type]).to eq("article")
                expect(json_data[:attributes]).to eq(
                    title: article.title,
                    content: article.content,
                    slug: article.slug
                )
            end
        end
    end

    describe "#create" do
        subject { post :create }
        context "when no token is provided" do
            it_behaves_like "forbidden_request"
        end

        context "when invalid token is provided" do
            before { request.headers['authorization'] = "Invalid Token"}
            it_behaves_like "forbidden_request"
        end

        context "when valid token is provided" do
            let(:user) { create :user }
            let(:access_token) { user.create_access_token}
            before { request.headers['authorization'] = "Bearer #{access_token.token}"}
            let(:invalid_attributes) {
               { data: {
                    attributes: {
                        title: '',
                        content: ''
                    }
                }}
            }

            subject { post :create} 

            it "should return 422 status code" do
                post :create
                expect(response).to have_http_status(422)
            end

            it "should return proper error response" do
                post :create, :params => invalid_attributes
                puts "response: #{json}"
                expect(json[:errors]).to include({
                    :detail => "can't be blank",
                    :source=>{:pointer=>"/data/attributes/title"}
                },
                {
                    :detail => "can't be blank",
                    :source=>{:pointer=>"/data/attributes/content"}
                },
                {
                    :detail => "can't be blank",
                    :source=>{:pointer=>"/data/attributes/slug"}
                }
            )
            end


        end
    end
end