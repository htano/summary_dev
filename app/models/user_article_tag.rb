class UserArticleTag < ActiveRecord::Base
  belongs_to :user_atricle

  #記事登録時にタグを設定するメソッド
  def self.edit_user_article_tag(user_article_id, tag_list)
    user_article_tag_list = where(:user_article_id => user_article_id)
    if user_article_tag_list.length == 0
      tag_list.each do |tag|
        user_article_tag = UserArticleTag.create(:user_article_id => user_article_id, :tag => tag)
      end
    else
      user_article_tag_list.each do |user_article_tag|
        if tag_list.include?(user_article_tag.tag)
          tag_list.delete(user_article_tag.tag)
        else
          user_article_tag.destroy
        end
      end

      tag_list.each do |tag|
        user_article_tag = UserArticleTag.craete(:user_article_id => user_article_id, :tag => tag)
      end
    end
  end
end
