class GoodSummary < ActiveRecord::Base
  belongs_to :user
  belongs_to :summary
  validates(:user_id,
            :uniqueness => {:scope => :summary_id})
end
