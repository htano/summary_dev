class U010User < ActiveRecord::Base
  has_many :r010_user_articles, :dependent => :destroy
  has_many :s010_summaries, :dependent => :destroy
end
