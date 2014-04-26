class User < ActiveRecord::Base
  MAIL_STATUS_UNDEFINED   = nil
  MAIL_STATUS_PROVISIONAL = 1
  MAIL_STATUS_DEFINITIVE  = 2
  MAIL_STATUS_ERROR       = 3
  CLUSTER_DECAY_DELTA = 0.95
  USER_CLUSTER_MAX_NUM = 20
  DEFAULT_USER_ICON_PATH = "/images/medium/no_image.png"
  
  if Rails.env.production?
    has_attached_file(
      :avatar, 
      :styles => { medium: '100x100>' }, 
      :default_url => "/images/:style/no_image.png",
    )
  else
    has_attached_file(
      :avatar, 
      :styles => { medium: '100x100>' }, 
      :default_url => "/images/:style/no_image.png",
      :url => "/images/:class/:attachment/:id_partition/:style/:filename",
      :path => "#{Rails.root}/public/images/:class/:attachment/:id_partition/:style/:filename"
    )
  end

  validates :name, :uniqueness => true
  validates :open_id,   :uniqueness => true
  #validates :mail_addr, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }
  validates :mail_addr_status, inclusion: { in: [MAIL_STATUS_UNDEFINED, MAIL_STATUS_PROVISIONAL, MAIL_STATUS_DEFINITIVE, MAIL_STATUS_ERROR] }

  has_many :favorite_users, :dependent => :destroy
  has_many :user_articles, :dependent => :destroy
  has_many :summaries, :dependent => :destroy
  has_many :good_summaries, :dependent => :destroy

  # Class method
  def self.get_readers_list(article)
    user_ids = article.user_articles.select(:user_id)
    return User.where(:id => user_ids).where(:yuko_flg => true).where(:public_flg => true)
  end

  def self.get_user_by_openid(openid)
    return where(["open_id = ? and yuko_flg = ?", openid, true]).first
  end

  def self.get_user_by_login_token(login_token, ip_address)
    return where(["keep_login_token = ? and yuko_flg = ? and keep_login_expire > ? and keep_login_ip = ?", login_token, true, Time.now, ip_address]).first
  end

  def self.regist(uname, openid)
    error_message = nil
    if uname
      uname = uname.downcase
      if uname =~ /^[A-Za-z0-9_\-]{4,20}$/
        created_user = create( name: uname, open_id: openid, yuko_flg: true, last_login: Time.now  )
        if created_user.new_record?
          error_message = "Error: '" + uname + "' has already existed."
        end
      else
        error_message = "Error: User name's characters are only allowed 'a-z', '0-9', '_', '-'. And the name length is allowed from 4 to 32 characters."
      end
    else
      error_message = "Fatal Error: Internal Server Error."
    end
    return error_message
  end

  # Instance Method
  def update_mypage_access
    self.last_mypage_access = Time.now
    return self.save
  end

  def update_last_login
    self.last_login = Time.now
    return self.save
  end

  def update_keep_login(ip_address)
    self.keep_login_token = SecureRandom.uuid
    self.keep_login_ip = ip_address
    self.keep_login_expire = Time.now + 3.days
    return self.save
  end

  def update_mail_address(email)
    self.mail_addr = email
    self.mail_addr_status = MAIL_STATUS_PROVISIONAL
    self.token_uuid = SecureRandom.uuid
    self.token_expire = Time.now + 3.days
    return self.save
  end

  def authenticate_updating_mailaddr(url_token_uuid)
    if url_token_uuid == self.token_uuid
      if self.token_expire > Time.now
        self.mail_addr_status = MAIL_STATUS_DEFINITIVE
        return self.save
      end
    end
    return false
  end

  def update_image_path(img_path)
    self.prof_image = img_path
    return self.save
  end

  def get_notifying_articles
    new_articles = Hash.new
    self.user_articles.where(read_flg: false).each do |user_article|
      Summary.where(["article_id = ? and user_id != ? and updated_at > ?", user_article.article_id, user_article.user_id, self.last_mypage_access]).each do |summary|
        unless new_articles[user_article.article_id]
          new_articles[user_article.article_id] = Article.find(user_article.article_id)
        end
      end
    end
    return new_articles
  end

  def reset_keep_login_info
    self.keep_login_token = nil
    self.keep_login_expire = nil
    self.keep_login_ip = nil
    return self.save
  end

  def add_cluster_id(adding_cluster_id)
    if adding_cluster_id != 0
      cluster_hash = Hash.new(0.0)
      if self.cluster_vector
        self.cluster_vector.split(",").each do |elem|
          cluster_id, value = elem.split(":")
          cluster_hash[cluster_id.to_i] = 
            value.to_f * CLUSTER_DECAY_DELTA
        end
      end
      cluster_hash[adding_cluster_id.to_i] += 1.0
      cluster_num = 0
      new_cluster_array = Array.new
      cluster_hash.sort_by{|k,v| -v}.each do |cluster_id, value|
        if cluster_num < USER_CLUSTER_MAX_NUM
          new_cluster_array.push(
            cluster_id.to_s + ":" + value.to_s
          )
        end
        cluster_num += 1
      end
      self.cluster_vector = new_cluster_array.join(",")
      self.save
    end
  end

  def delete_cluster_id(target_cluster_id)
    cluster_hash = Hash.new(0.0)
    if self.cluster_vector
      self.cluster_vector.split(",").each do |elem|
        cluster_id, value = elem.split(":")
        cluster_hash[cluster_id.to_i] = value.to_f
      end
    end
    cluster_hash[target_cluster_id] -= 1.0
    new_cluster_array = Array.new
    cluster_hash.each do |cluster_id, value|
      if value > 0.0
        new_cluster_array.push(cluster_id.to_s + ":" + value.to_s)
      end
    end
    self.cluster_vector = new_cluster_array.join(",")
    self.save
  end

  def get_followers_count
    return FavoriteUser.count(:all, :conditions => {:favorite_user_id => self.id})
  end

  def prof_image
    if(self["prof_image"] && 
       self["prof_image"] =~ /^http/ && 
       self.avatar.url(:medium) == DEFAULT_USER_ICON_PATH)
      return self["prof_image"]
    else
      return self.avatar.url(:medium)
    end
  end
end
