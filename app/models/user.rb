class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  enum role: { user: 0, admin: 1 }

  validates :email,presence: true 
  validates :password,presence: true
  validates :password_confirmation,presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

end
  