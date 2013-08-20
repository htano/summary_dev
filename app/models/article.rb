class Article < ActiveRecord::Base
  has_many :user_articles, :dependent => :destroy
  has_many :summaries, :dependent => :destroy
end
