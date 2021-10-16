class ArticlesController < ApplicationController 
    def index
        render json: serializer.new(Article.recent), status: :ok
    end

    def serializer 
        ArticleSerializer    
    end
end