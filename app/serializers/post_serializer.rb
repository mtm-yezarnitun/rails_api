class PostSerializer
  include JSONAPI::Serializer

  attributes :title, :body, :created_at, :updated_at
  
  attribute :image_urls do |post|
    post.images.map { |img| Rails.application.routes.url_helpers.url_for(img) }
  end
end
