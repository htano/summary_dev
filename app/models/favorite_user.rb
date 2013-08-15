class FavoriteUser < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :uniqueness => {:scope => :favorite_user_id}
end
