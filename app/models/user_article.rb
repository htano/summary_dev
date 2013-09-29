class UserArticle < ActiveRecord::Base
  belongs_to :user
  belongs_to :article
  has_many :user_article_tags, :dependent => :destroy
  scope :read, lambda { where(:read_flg => true) }
  scope :unread, lambda { where(:read_flg => false) }
  scope :favorite, lambda { where(:favorite_flg => true) }

   #ユーザーが最近あとで読むした記事に設定したタグ情報を取得するメソッド
  def self.get_recent_tag(user_id)
    first_index = 0
    last_index = 9
    recent_tags = joins(:user_article_tags).where("user_id" => user_id).group("tag").order("user_article_tags.created_at desc").count("tag").keys
    return recent_tags[first_index..last_index]
  end
end