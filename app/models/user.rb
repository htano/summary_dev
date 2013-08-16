class User < ActiveRecord::Base
  validates :name, :uniqueness => true
  validates :open_id,   :uniqueness => true
  has_many :favorite_users, :dependent => :destroy
  has_many :user_articles, :dependent => :destroy
  has_many :summaries, :dependent => :destroy
  has_many :good_summaries, :dependent => :destroy

  # TODO: 全体的にイケてない実装。全メソッドは毎回openidを渡すのではなく、getLoginUserからインスタンスメソッドで呼ぶべきでした。
  def self.isExists?(openid)
    @current_user = where(["open_id = ? and yuko_flg = ?", openid, true]).first
    return (@current_user != nil)
  end

  def self.getName(openid)
    @current_user = where(["open_id = ? and yuko_flg = ?", openid, true]).first
    if @current_user != nil
      return where(["open_id = ? and yuko_flg = ?", openid, true]).first.name
    else
      return nil
    end
  end

  def self.regist(uname, openid)
    @error_message = nil
    if uname
      #uname = uname.downcase
      if uname =~ /^[A-Za-z0-9_\-]{4,32}$/
        @created_user = create( name: uname, open_id: openid, yuko_flg: true, last_login: Time.now  )
        if @created_user.new_record?
          @error_message = "Error: '" + uname + "' has already existed."
        end
      else
        @error_message = "Error: User name's characters are only allowed 'a-z', '0-9', '_', '-'. And the name length is allowed from 4 to 32 characters."
      end
    else
      @error_message = "Fatal Error: Internal Server Error."
    end
    return @error_message
  end

  def self.getMailAddr(openid)
    return where(["open_id = ? and yuko_flg = ?", openid, true]).first.mail_addr
  end

  def self.updateLastLoginTime?(openid)
    @current_user = where(["open_id = ? and yuko_flg = ?", openid, true]).first
    @current_user.last_login = Time.now
    return @current_user.save
  end

  def self.getLastLogIn(openid)
    return where(["open_id = ? and yuko_flg = ?", openid, true]).first.last_login
  end

  def self.updateMailAddr(email, openid)
    @current_user = where(["open_id = ? and yuko_flg = ?", openid, true]).first
    @current_user.mail_addr = email
    return @current_user.save
  end

  def self.getUserObj(openid)
    return where(["open_id = ? and yuko_flg = ?", openid, true]).first
  end

  def self.updateImagePath(openid, img_path)
    @current_user = where(["open_id = ? and yuko_flg = ?", openid, true]).first
    @current_user.prof_image = img_path
    return @current_user.save
  end

  # Instance Method
  def updateMypageAccess
    self.last_mypage_access = Time.now
    return self.save
  end

  def getNotifyingArticles
    @new_articles = Hash.new
    self.user_articles.where(read_flg: false).each do |user_article|
      Summary.where(["article_id = ? and user_id != ? and updated_at > ?", user_article.article_id, user_article.user_id, self.last_mypage_access]).each do |summary|
        if !@new_articles[user_article.article_id]
          @new_articles[user_article.article_id] = Article.find(user_article.article_id)
        end
      end
    end
    return @new_articles
  end
  
end
