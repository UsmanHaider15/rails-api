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
        begin
            article.save!
            render json: serializer.new(article), status: 201
        rescue
            render json: article, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
        end
    end

    def article_params
        if(params.has_key?(:data) && params.has_key?(:attributes))
            params.require(:data).require(:attributes)
        .permit(:title, :content, :slug)
        else
            ActionController::Parameters.new
        end 
    end

    def serializer 
        ArticleSerializer    
    end

end 