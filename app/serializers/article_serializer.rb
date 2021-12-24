class ArticleSerializer
  include ActiveModel::Serialization

  include JSONAPI::Serializer
  attributes :title, :content, :slug
end
