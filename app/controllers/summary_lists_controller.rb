class SummaryListsController < ApplicationController

	def index
		@article = Article.find_by id: params[:articleId]
		#if(@summary != nil)
	        #        @article  = Article.find_by id: @summary.article_id
		#	@sumUser =  User.find_by id: @summary.user_id
		#end
	end
       
        def show

        end
end
