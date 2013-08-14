class SummaryListsController < ApplicationController
#changed at improving calcration system. but, calcration will be slowly...
NUM_CALC_ARRAY = 10

	def index
		@article = Article.find_by id: params[:articleId]
		
                #create array for calcration 
                arrayCount = 0
                Summary.where(:article_id =>@article.id).find_each do |summary|  
		
			#calcurate sum of the goodSummaryPoint from summary_id.
			goodSummaryPoint = 0
			
			GoodSummary.where(:summary_id => summary.id.find_each do
				goodSummaryPoint++
			end
		
			#calcu

	
			#if array is already max, break
			if arrayCount >= NUM_CALC_ARRAY then
				break
			end 
		end 
                
		
		
		#if(@summary != nil)
	        #        @article  = Article.find_by id: @summary.article_id
		#	@sumUser =  User.find_by id: @summary.user_id
		#end
	end
       
        def show

        end
end
