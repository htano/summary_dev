class SummaryController < ApplicationController
  def edit
    article = A010Article.where(:article_id => params[:article_id]).first;
    @url = article.article_url;
    @title = article.article_title;
    @user_name = "#{params[:user_name]}";
    @user_id = findUserIdByUserName(@user_name);
 
    summary = S010Summary.where(:user_id => @user_id,:article_id => params[:article_id]).first;
    if summary
      #すでに当該記事に対して要約が登録されていた場合、以下の処理をする
      @summary_content = summary.summary_content;
    end
  end

  def edit_confirm
  	article = A010Article.where(:article_id => params[:article_id]).first;
    @url = article.article_url;
    @title = article.article_title;
  	@user_name = "#{params[:user_name]}";
  	@user_id = findUserIdByUserName(@user_name);
  	@summary_content = "#{params[:summary_content]}";
  end


  def edit_complete
    @user_name = "#{params[:user_name]}";
    @user_id = findUserIdByUserName(@user_name);
    summary = S010Summary.where(:user_id => @user_id,:article_id => params[:article_id]).first;
    if summary
      #すでに当該記事に対して要約が登録されていた場合、以下の処理をする
      summary.update_attribute(:summary_content, params[:summary_content]);
      if summary.save
        redirect_to :action => "show";
      end
    else
      #当該記事に対して要約が登録されていなかった場合、以下の処理をする
      summary_id = createSummaryID();
      @summary = S010Summary.new(:summary_id => summary_id,:summary_content => params[:summary_content],:user_id => @user_id,:article_id => params[:article_id]);
      if @summary.save
        redirect_to :action => "show";
      end
    end 
  end

  def show
    article = A010Article.where(:article_id => params[:article_id]).first;
    @url = article.article_url;
    @title = article.article_title;
    @user_name = "#{params[:user_name]}";
    @user_id = findUserIdByUserName(@user_name);
    @article_id = "#{params[:article_id]}";

    summary = S010Summary.where(:user_id => @user_id,:article_id => params[:article_id]).first;
    @summary = summary.summary_content;
    @msg = "要約が登録出来ました！"
  end

  #要約IDの導出
  #すでに登録されているIDをインクリメントして導出する。1件も要約が登録されていない場合は1を返す。
  def createSummaryID
      summary = S010Summary.first(:order => "created_at DESC");
      if summary
        summary_id = summary.summary_id;
        return summary_id += 1;
      else
        return summary_id = 1;
      end
  end

  def findUserIdByUserName(user_name)
    user = U010User.where(:user_name => params[:user_name]).first;
    return user.user_id;
  end

end
  