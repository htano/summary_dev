class Article < ActiveRecord::Base
	has_many :user_articles, :dependent => :destroy
	has_many :summaries, :dependent => :destroy

	def getMarkedUser
		return self.user_articles.count
	end

	def isRead(user)
		unless user == nil then
			userArticleForIsRead = self.user_articles.find_by(:user_id => user.id)
			unless  userArticleForIsRead == nil then
				
				if userArticleForIsRead.read_flg == true then
				
                isRead = true

				else
			    	
				isRead = false

				end

			else
				isRead = false 
			end
		else
			isRead = false 
		end	
		return isRead
	end

	def getSortedSummaryList(user)
		#create array for calcration 
		scoreItem = Struct.new(:summary,:goodSummaryPoint)
		scoreList = Array.new 
		isGoodCompleted = Array.new

		self.summaries.each_with_index do |summary,i|  

			#calcurate goodSummaryPoint 
			goodSummaryPoint = summary.good_summaries.count

			#scoreItem
			scoreList[i] = scoreItem.new(summary, goodSummaryPoint)
		end 


		#sort summary list
		#
		#
		#Under Construction
		scoreList_sorted = scoreList.sort{|i,j|
				j.goodSummaryPoint<=>i.goodSummaryPoint								 
		}
		#
		#

		summaryItem = Struct.new(:summary, :user, :summaryPoint, :isGoodCompleted) 
		summaryList = Array.new
		#insert to each params  
		scoreList_sorted.each_with_index do |scoreItem, i| 				
			unless user == nil then
				unless scoreItem.summary.good_summaries.find_by(:user_id => user.id) == nil then 
					isGoodCompleted = true
				else
					isGoodCompleted = false 
				end
			else
				isGoodCompleted = false 
			end	
			summaryList[i] = summaryItem.new(scoreItem.summary, scoreItem.summary.user,scoreItem.goodSummaryPoint,isGoodCompleted)  
		end

		return summaryList
	end

end
