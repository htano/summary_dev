class FavoriteUser < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  validates :user_id, :uniqueness => {:scope => :favorite_user_id}
end
