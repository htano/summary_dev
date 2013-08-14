class User < ActiveRecord::Base
  validates :name, :uniqueness => true
  validates :open_id,   :uniqueness => true
  has_many :favorite_users, :dependent => :destroy
  has_many :user_articles, :dependent => :destroy
  has_many :summaries, :dependent => :destroy
  has_many :good_summaries, :dependent => :destroy
  def self.isExists?(openid)
    @current_user = where(["open_id = ? and yuko_flg = ?", openid, true]).first
    return (@current_user != nil)
  end

  def self.getName(openid)
    return where(["open_id = ? and yuko_flg = ?", openid, true]).first.name
  end

  def self.regist?(uname, openid)
    @created_user = create( name: uname, open_id: openid, yuko_flg: true, last_login: Time.now  )
    return !(@created_user.new_record?)
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
end
