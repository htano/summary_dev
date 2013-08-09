class U010User < ActiveRecord::Base
  def self.isExists?(openid)
    @current_user = where(["open_id = ? and yuko_flg = ?", openid, true]).first
    return (@current_user != nil)
  end

  def self.getName(openid)
    return where(["open_id = ? and yuko_flg = ?", openid, true]).first.user_name
  end
end
