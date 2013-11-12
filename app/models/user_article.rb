class UserArticle < ActiveRecord::Base
  belongs_to :user
  belongs_to :article, :counter_cache => true
  has_many :user_article_tags, :dependent => :destroy
  scope :read, lambda { where(:read_flg => true) }
  scope :unread, lambda { where(:read_flg => false) }
  scope :favorite, lambda { where(:favorite_flg => true) }

  def self.edit_user_article(user_id, article_id)
    user_article = UserArticle.find_by_user_id_and_article_id(user_id, article_id)
    if user_article == nil
      user_article = UserArticle.create(:user_id => user_id, :article_id => article_id, :read_flg => false)
    end
    return user_article
  end

  #ユーザーが最近あとで読むした記事に設定したタグ情報を取得するメソッド
  def self.get_recent_tag(user_id)
    first_index = 0
    last_index = 9
    recent_tags = joins(:user_article_tags).where("user_id" => user_id).order("user_article_tags.created_at desc").pluck("user_article_tags.tag").uniq
    return recent_tags[first_index..last_index]
  end

  #前回登録時に設定したタグ情報を取得するメソッド
  def get_set_tag()
    first_index = 0
    last_index = 9
    set_tags = self.user_article_tags.order("user_article_tags.created_at desc").pluck(:tag).uniq
    return set_tags[first_index..last_index]
  end
end