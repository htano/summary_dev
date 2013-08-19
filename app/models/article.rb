class Article < ActiveRecord::Base
  has_many :user_articles, :dependent => :destroy
  has_many :summaries, :dependent => :destroy
  def self.returnArticle(article_id)
  	@article = where(["id = ?", article_id]).first
  	if @article == nil then
  		return nil
  	else
  		return @article
  	end
  end
end
