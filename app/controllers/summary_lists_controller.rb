class SummaryListsController < ApplicationController
	def index
		@article = Article.find_by id: params[:articleId]
		
                #create array for calcration 
                arrayCount = 0
		scoreList = Array.new 

                Summary.where(:article_id => @article.id).find_each do |summary|  
		
			#calcurate sum of the goodSummaryPoint from summary_id.
			goodSummaryPoint = GoodSummary.where(:summary_id => summary.id).count
			
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

		#insert to @summarys 
		@summarys = Array.new
		@sumUsers = Array.new
		scoreList.each_with_index do |scoreItem, i| 				
			@summarys[i] = Summary.find_by id: scoreItem[0]
			@sumUsers[i] = User.find_by id: @summarys[i].user_id  
		end
		
	end
       
        def show

        end
end
