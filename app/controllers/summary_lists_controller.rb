class SummaryListsController < ApplicationController
	def index
		#check current loginuser
		@article = Article.find_by id: params[:articleId]
		if @article == nil then
			redirect_to :controller => "mypage", :action => "index" 
			return
		end
		@user = getLoginUser
		@summaryList = @article.getSortedSummaryList(@user, @article)
        @isReadArticle = true
		# @isReadArticle = @article.isRead(@user, @article)
	end

	def goodSummary 
		if getLoginUser == nil then
			redirect_to :controller => "consumer", :action => "index"
			return	
		end
		goodSummary = GoodSummary.new(:user_id => getLoginUser.id, :summary_id =>params[:summaryId]) 

		if goodSummary.save
			@listIndex = params[:listIndex]
			render
		end
	end

	def cancelGoodSummary 
		if getLoginUser == nil then
			redirect_to :controller => "consumer", :action => "index"
			return	
		end

		GoodSummary.where(:user_id => getLoginUser.id).where(:summary_id =>params[:summaryId]).delete_all 
			@listIndex = params[:listIndex]
			render
	end

=begin
	def isRead 
		if getLoginUser == nil then
			redirect_to :controller => "consumer", :action => "index"
			return	
		end
		 userArticle = UserArticle.where(:user_id => getLoginUser.id).where(:article_id =>params[:articleId]) 
         userArticle.read_flg = true
		if userArtcile.save
			render
		end
	end

	def cancelIsRead 
		if getLoginUser == nil then
			redirect_to :controller => "consumer", :action => "index"
			return	
		end
		 userArticle = UserArticle.where(:user_id => getLoginUser.id).where(:article_id =>params[:articleId]) 
         userArticle.read_flg = false 
		if userArtcile.save
			render
		end

	end
=end
end
