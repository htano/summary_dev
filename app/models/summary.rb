class Summary < ActiveRecord::Base
  belongs_to :user
  belongs_to :article
  has_many :good_summaries, :dependent => :destroy
end
