class SummaryListsController < ApplicationController

	def index
		@article = A010Article.find_by id: params[:articleId]
		#if(@summary != nil)
	        #        @article  = A010Article.find_by article_id: @summary.article_id
		#	@sumUser =  U010User.find_by user_id: @summary.user_id
		#end
	end
       
        def show

        end
end
