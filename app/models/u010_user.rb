class U010User < ActiveRecord::Base
  has_many :u011_favorite_users, :dependent => :destroy
  has_many :r010_user_articles, :dependent => :destroy
  has_many :s010_summaries, :dependent => :destroy
end
