class SummaryListsController < ApplicationController
	def index
		@article = Article.find_by id: params[:articleId]

		#create array for calcration 
		arrayCount = 0
		scoreList = Array.new 
		
		@isGoodCompleted = Array.new

		Summary.where(:article_id => @article.id).find_each do |summary|  

			#calcurate sum of the goodSummaryPoint from summary_id.
			goodSummary = GoodSummary.where(:summary_id => summary.id)
			goodSummaryPoint = goodSummary.count
			unless goodSummary.find_by(:user_id => getLoginUser.id) == nil then 
				@isGoodCompleted[arrayCount] = true
			else
				@isGoodCompleted[arrayCount] = false 
			end	

			#scoreItem
			scoreItem = Array.new([summary.id,goodSummaryPoint])
			scoreList[arrayCount] = scoreItem

			#inc arrayCount
			arrayCount = arrayCount + 1

		end 


		#sort summary list
		#
		#
		#Under Construction
		#
		#

		#insert to each params  
		@summarys = Array.new
		@sumUsers = Array.new
		@goodSummaryPoint = Array.new
		scoreList.each_with_index do |scoreItem, i| 				
			@summarys[i] = Summary.find_by id: scoreItem[0]
			@sumUsers[i] = User.find_by id: @summarys[i].user_id  
			@goodSummaryPoint[i] = scoreList[i][1] 
		end

	end

	def goodSummary 

		goodSummary = GoodSummary.new(:user_id => getLoginUser.id, :summary_id =>params[:summaryId]) 

		if goodSummary.save
			#nothing yet
			redirect_to :action => "index", :artcileId =>params[:articleId]
		end

	end
end
