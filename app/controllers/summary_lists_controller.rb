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
		@user = getLoginUser
		@summaryList = @article.getSortedSummaryList(@user, @article)
		@isReadArticle = @article.isRead(@user, @article)
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

	def isRead 
		if getLoginUser == nil then
			redirect_to :controller => "consumer", :action => "index"
			return	
		end
        userArticleForIsRead=UserArticle.where(:user_id=>getLoginUser.id).where(:article_id=>params[:articleId])

        unless userArticleForIsRead == nil then
			userArticleForIsRead.read_flg = true	
		else
            userArticleForIsRead=UserArticle.new(:user_id=>getLoginUser.id,:article_id=>params[:articleId],:read_flg=>true)
		end

        if userArticleForIsRead.save
			oppai1
			render

		else
			oppai3
		end
	end
	
	def cancelIsRead 
		if getLoginUser == nil then
			redirect_to :controller => "consumer", :action => "index"
			return	
		end

        userArticleForIsRead=UserArticle.where(:user_id=>getLoginUser.id).where(:article_id=>params[:articleId])

        unless userArticleForIsRead == nil then
			userArticleForIsRead.read_flg = false
		else
            userArticleForIsRead=UserArticle.new(:user_id=>getLoginUser.id,:article_id=>params[:articleId],:read_flg=>false)
		end

        if userArticleForIsRead.save
			oppai2
			render
			else
			
			oppai4
			end

	end

end
