class U010User < ActiveRecord::Base
  validates :user_name, :uniqueness => true
  validates :open_id,   :uniqueness => true
  def self.isExists?(openid)
    @current_user = where(["open_id = ? and yuko_flg = ?", openid, true]).first
    return (@current_user != nil)
  end

  def self.getName(openid)
    return where(["open_id = ? and yuko_flg = ?", openid, true]).first.user_name
  end

  def self.regist?(uname, openid)
    @created_user = create( user_name: uname, open_id: openid, yuko_flg: true, last_login: Time.now  )
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
end
