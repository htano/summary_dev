class UserArticleTag < ActiveRecord::Base
  belongs_to :user_atricle

  def self.editTag(user_article_id, tag_list)
    user_article_tag_list = where(:user_article_id => user_article_id)
    if user_article_tag_list.length != 0
      #同一user_article_idのタグ情報が存在する場合
      user_article_tag_list.each do |user_article_tag|
        if tag_list.include?(user_article_tag.tag)
          tag_list.delete(user_article_tag.tag)
        else
          #前回以前に登録されていたが、今回指定されなかったタグは削除する
          user_article_tag.destroy
        end
      end

      tag_list.each do |tag|
        #同一user_article_idにtagの内容が存在しない場合新しい情報を格納する
        user_article_tag = UserArticleTag.new(:user_article_id => user_article_id, :tag => tag)
        user_article_tag.save
      end
    else
      #同一user_article_idのタグ情報が存在しない場合
      tag_list.each do |tag|
        user_article_tag = UserArticleTag.new(:user_article_id => user_article_id, :tag => tag)
        user_article_tag.save
      end
    end
  end
end
