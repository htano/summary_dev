class UserArticle < ActiveRecord::Base
  belongs_to :user
  belongs_to :article
  has_many :user_article_tags, :dependent => :destroy
end
