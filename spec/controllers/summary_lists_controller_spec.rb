require 'spec_helper'

describe SummaryListsController do
  fixtures(:all)

  describe "GET #index with registed article_id" do
    before do
      @article_id = 1
      get :index, :article_id => @article_id
    end
    it "get http 2xx response"do
      expect(response).to be_success
    end
    it "get index template"do
      expect(response).to render_template('index')
    end
    it "get article correctry"do
      @article == Article.where(:id => @article_id).first
    end
  end

  describe "GET #index with unregisted article_id" do
    before do
      @article_id = -1
      get :index, :article_id => @article_id 
    end
    it "get http 3xx response"do
      expect(response).to be_redirect
    end
    it "ridirect to mypage"do
      expect(response).to redirect_to :controller => 'mypage',
                                      :action => 'index'
    end
  end

  describe "POST #good_summary without signing in" do
    before do
      summary_id = 1
      list_index = 2
      article_id = 4
      post :good_summary, :article_id => article_id, :summary_id => summary_id, :list_index => list_index
    end
    it "get http 3xx response"do
      expect(response).to be_redirect
    end
    it "redirect to login page" do
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #good_summary with signing in" do
    before do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @summary_id = 1
      list_index = 2
      article_id = 4
      post :good_summary, :article_id => article_id, :summary_id => @summary_id, :list_index => list_index
    end
#    it "get http 3xx response"do
#      expect(response).to be_redirect
#    end
#    it "back to summarylists index" do
#      expect(response).to redirect_to :controller => 'summary_lists', 
#                                      :action => 'index'
#    end
    it "good summary is registerd" do
      GoodSummary.where(:user_id => @login_user.id).where(:summary_id =>@summary_id).exists?
    end
  end

  describe "POST #cancel_good_summary without signing in" do
    before do
      summary_id = 1
      list_index = 2
      article_id = 4
      post :cancel_good_summary, :article_id => article_id,
        :summary_id => summary_id, :list_index => list_index
    end
    it "get http 3xx response"do
      expect(response).to be_redirect
    end
    it "redirect to login page" do
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #cancel_good_summary with signing in" do
    before do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      summary_id = 1
      list_index = 2
      article_id = 4
      post :cancel_good_summary, :article_id => article_id, 
        :summary_id => summary_id, :list_index => list_index
    end
    it "good summary is canceled" do
      !(GoodSummary.where(:user_id => @login_user.id).where(:summary_id =>@summary_id).exists?)
    end
#    it "get http 3xx response"do
#      expect(response).to be_redirect
#    end
#    it "redirect to login page" do
#      expect(response).to redirect_to :controller => 'summary_lists', 
#                                      :action => 'index'
#    end
  end

  describe "POST #follow without signing in" do
    before do
      follow_user_id = 4
      list_index = 2
      post :follow, :list_index => list_index, :follow_user_id => follow_user_id
    end
    it "get http 3xx response"do
      expect(response).to be_redirect
    end
    it "redirect to login page" do
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #unfollow without signing in" do
    before do
      unfollow_user_id = 4
      list_index = 2
      post :unfollow, :list_index => list_index, :unfollow_user_id => unfollow_user_id
    end
    it "get http 3xx response"do
      expect(response).to be_redirect
    end
    it "redirect to login page" do
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

#  describe "POST #unfollow with signing in" do
#    before do
#      session[:openid_url] = "oauth://twitter/12345"
#      @login_user = User.find_by_id(2)
#      unfollow_user_id = 1 
#      list_index = 2
#      post :unfollow, :list_index => list_index, :unfollow_user_id => unfollow_user_id
#    end
#    it "get http 3xx response"do
#      expect(response).to be_redirect
#    end
#    it "back to summarylists index" do
#      expect(response).to redirect_to :controller => 'summary_lists', 
#                                      :action => 'index'
#    end
#  end

#  describe "POST #follow with signing in" do
#    before do
#      session[:openid_url] = "oauth://twitter/12345"
#      @login_user = User.find_by_id(1)
#      follow_user_id = 32
#      list_index = 2
#      post :follow, :list_index => list_index, :follow_user_id => follow_user_id
#    end
#
#    it "follow result check" do
#    end
#
#  end
#  describe "POST #unfollow with signing in" do
#    before do
#      session[:openid_url] = "oauth://twitter/12345"
#      @login_user = User.find_by_id(1)
#      unfollow_user_id = 32
#      list_index = 2
#      post :unfollow, :list_index => list_index, :unfollow_user_id => unfollow_user_id
#    end
#
#    it "unfollow result check" do
#    end
#
#  end
  describe "POST #read without signing in" do
    before do
      article_id = 4
      post :read, :article_id => article_id
    end
    it "get http 3xx response"do
      expect(response).to be_redirect
    end
    it "redirect to login page" do
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #read with signing in" do
    before do
      session[:openid_url] = "oauth://twitter/12345"
      @user_id
      @login_user = User.find_by_id(@user_id)
      @article_id = 4
      post :read, :article_id => @article_id
    end
    it "read it later is registed" do
      UserArticle.where(:user_id => @user_id,:article_id => @article_id).exists?

    end
  end

end
