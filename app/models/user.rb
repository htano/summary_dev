class User < ActiveRecord::Base
  MAIL_STATUS_UNDEFINED   = nil
  MAIL_STATUS_PROVISIONAL = 1
  MAIL_STATUS_DEFINITIVE  = 2
  MAIL_STATUS_ERROR       = 3
  validates :name, :uniqueness => true
  validates :open_id,   :uniqueness => true
  #validates :mail_addr, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }
  validates :mail_addr_status, inclusion: { in: [MAIL_STATUS_UNDEFINED, MAIL_STATUS_PROVISIONAL, MAIL_STATUS_DEFINITIVE, MAIL_STATUS_ERROR] }
  has_many :favorite_users, :dependent => :destroy
  has_many :user_articles, :dependent => :destroy
  has_many :summaries, :dependent => :destroy
  has_many :good_summaries, :dependent => :destroy

  # Class method
  def self.getUserObj(openid)
    return where(["open_id = ? and yuko_flg = ?", openid, true]).first
  end

  def self.regist(uname, openid)
    @error_message = nil
    if uname
      #uname = uname.downcase
      if uname =~ /^[A-Za-z0-9_\-]{4,20}$/
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

  # Instance Method
  def updateMypageAccess
    self.last_mypage_access = Time.now
    return self.save
  end

  def updateLastLoginTime
    self.last_login = Time.now
    return self.save
  end

  def updateMailAddr(email)
    self.mail_addr = email
    self.mail_addr_status = MAIL_STATUS_PROVISIONAL
    self.token_uuid = SecureRandom.uuid
    self.token_expire = Time.now + 3.days
    return self.save
  end

  def authenticateUpdateMailAddr(url_token_uuid)
    if url_token_uuid == self.token_uuid
      if self.token_expire > Time.now
        self.mail_addr_status = MAIL_STATUS_DEFINITIVE
        return self.save
      end
    end
    return false
  end

  def updateImagePath(img_path)
    self.prof_image = img_path
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
