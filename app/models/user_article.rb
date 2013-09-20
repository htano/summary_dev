class UserArticle < ActiveRecord::Base
  belongs_to :user
  belongs_to :article

  scope :read, lambda { where(:read_flg => true) }
  scope :unread, lambda { where(:read_flg => false) }
  scope :favorite, lambda { where(:favorite_flg => true) }
end
