class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  
  has_many :comments, dependent: :destroy
  has_many_attached :images
  
  def image_urls
    images.map { |img| Rails.application.routes.url_helpers.url_for(img) }
  end

end
