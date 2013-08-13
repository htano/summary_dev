class SummaryListsController < ApplicationController

	def index
		@user	  = U010User.find_by user_id: params[:userId]
		@summary = S010Summary.find_by summary_id: params[:summaryId]
		if(@summary != nil)
	                @article  = A010Article.find_by article_id: @summary.article_id
			@sumUser =  U010User.find_by user_id: @summary.user_id
		end
	end
       
        def show

        end
end
