require 'rails_helper'

RSpec.describe ArticlesController do
    describe "Article#index" do
        it "should return 200 status code" do
            get "/articles"
            expect(response).to have_http_status(:ok)
        end
        it "should return proper json response" do
            article = create(:article)
            get "/articles"
            body = JSON.parse(response.body).deep_symbolize_keys
            expect(body).to eq(
                data: [
                    {
                        id: article.id.to_s,
                        type: 'article',
                        attributes: {
                            title: article.title,
                            content: article.content,
                            slug: article.slug
                        }
                    }
                ]
            )

            # expect(response).to have_http_status(:ok)
        end
    end
end