class Summary < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :article, :counter_cache => true
  has_many :good_summaries, :dependent => :destroy
end
