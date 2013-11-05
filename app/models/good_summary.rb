class GoodSummary < ActiveRecord::Base
  belongs_to :user
  belongs_to :summary, :counter_cache => true
  validates(:user_id,
            :uniqueness => {:scope => :summary_id})
end
