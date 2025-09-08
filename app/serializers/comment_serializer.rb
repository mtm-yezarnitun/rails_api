class CommentSerializer
  include JSONAPI::Serializer

  attributes :body, :created_at, :updated_at

  belongs_to :user

  belongs_to :post

  attribute :user_email do |comment|
    comment.user.email
  end
end
