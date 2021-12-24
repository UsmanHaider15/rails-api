class ArticlesController < ApplicationController 
    include Paginable
    skip_before_action :authorize!, only: [:index, :show]

    def index
        paginated = paginate(Article.recent)

        options = { meta: paginated.meta.to_h, links: paginated.links.to_h }
        render json: serializer.new(paginated.items, options), status: :ok
    end

    def show
        article = Article.find(params[:id])
        render json: serializer.new(article), status: :ok
    end

    def create
        article = Article.new(article_params)
        if article.valid?
            
        else
            render json: article, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
        end
    end

    def article_params
        ActionController::Parameters.new
    end

    def serializer 
        ArticleSerializer    
    end

end 