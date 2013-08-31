class SummaryListsController < ApplicationController
    #TODO 画面からURL直打ちの回避
    def get_summary_num_for_chrome_extension
    	@url = "#{params[:url]}"
    	article = Article.find_by_url(@url);
    	if article != nil then
    		summary_num = Summary.count(:all, :conditions => {:article_id => article.id})
    		render :text => summary_num and return
    	else
    		render :text => 0 and return
    	end
    end

	def get_summary_list_for_chrome_extension
	  @url = "#{params[:url]}"
      article = Article.find_by_url(@url);
      if article == nil then
        render :json => nil and return
      else
      	summaries = article.summaries.find(:all,:limit => 10)
      	if summaries != nil then
      		render :json => summaries and return
      	else
      		render :json => nil and return
      	end
      end
	end

	def index
		#check current loginuser
			
		@article = Article.find_by id: params[:articleId]
		if @article == nil then
			redirect_to :controller => "mypage", :action => "index" 
			return
		end

		#create array for calcration 
		arrayCount = 0
		scoreList = Array.new 
		
		@isGoodCompleted = Array.new

		Summary.where(:article_id => @article.id).find_each do |summary|  

			#calcurate sum of the goodSummaryPoint from summary_id.
			goodSummary = GoodSummary.where(:summary_id => summary.id)
			goodSummaryPoint = goodSummary.count
			unless getLoginUser == nil then
				unless goodSummary.find_by(:user_id => getLoginUser.id) == nil then 
					@isGoodCompleted[arrayCount] = true
				else
					@isGoodCompleted[arrayCount] = false 
				end
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
		if getLoginUser == nil then
			redirect_to :controller => "consumer", :action => "index"
		    return	
		end
		goodSummary = GoodSummary.new(:user_id => getLoginUser.id, :summary_id =>params[:summaryId]) 

		if goodSummary.save
			#nothing yet
			redirect_to :action => "index", :artcileId =>params[:articleId]
		end

	end
end
