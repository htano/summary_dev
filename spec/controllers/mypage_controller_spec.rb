require 'spec_helper'

describe MypageController do
  fixtures(:all)

  describe "GET #index without signing in" do
    it "access to route without no parameters" do
      get :index
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
    it "access to route with the paramter of name" do
      get :index, :name => "summary"
      expect(response).to be_success
    end
    it "access to route with the paramter of name and main tab" do
      get :index, :name => "summary", :mpage => 1
      expect(response).to be_success
    end
    it "access to route with the paramter of name and summary tab" do
      get :index, :name => "summary", :spage => 1
      expect(response).to be_success
    end
    it "access to route with the paramter of name and favorite tab" do
      get :index, :name => "summary", :fpage => 1
      expect(response).to be_success
    end
    it "access to route with the paramter of name and read tab" do
      get :index, :name => "summary", :rpage => 1
      expect(response).to be_success
    end
    it "access to route for sorting created_at asc" do
      get :index, :name => "summary", :sort => "registered", :direction => "asc"
      expect(response).to be_success
    end
    it "access to route for sorting created_at desc" do
      get :index, :name => "summary", :sort => "registered", :direction => "desc"
      expect(response).to be_success
    end
    it "access to route for sorting summaries asc" do
      get :index, :name => "summary", :sort => "summaries", :direction => "asc"
      expect(response).to be_success
    end
    it "access to route for sorting summaries desc" do
      get :index, :name => "summary", :sort => "summaries", :direction => "desc"
      expect(response).to be_success
    end
    it "access to route for sorting reader asc" do
      get :index, :name => "summary", :sort => "reader", :direction => "asc"
      expect(response).to be_success
    end
    it "access to route for sorting reader desc" do
      get :index, :name => "summary", :sort => "reader", :direction => "desc"
      expect(response).to be_success
    end
  end

  describe "GET #index without signing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
    end
    it "access to route without no parameters" do
      get :index
    expect(response).to be_success
    end
    it "access to route with the paramter of main tab" do
      get :index, :mpage => 1
      expect(response).to be_success
    end
    it "access to route with the paramter of summary tab" do
      get :index, :spage => 1
      expect(response).to be_success
    end
    it "access to route with the paramter of favorite tab" do
      get :index, :fpage => 1
      expect(response).to be_success
    end
    it "access to route with the paramter of name and read tab" do
      get :index, :rpage => 1
      expect(response).to be_success
    end
    it "access to route for sorting created_at asc" do
      get :index, :sort => "registered", :direction => "asc"
      expect(response).to be_success
    end
    it "access to route for sorting created_at desc" do
      get :index, :sort => "registered", :direction => "desc"
      expect(response).to be_success
    end
    it "access to route for sorting summaries asc" do
      get :index, :sort => "summaries", :direction => "asc"
      expect(response).to be_success
    end
    it "access to route for sorting summaries desc" do
      get :index, :sort => "summaries", :direction => "desc"
      expect(response).to be_success
    end
    it "access to route for sorting reader asc" do
      get :index, :sort => "reader", :direction => "asc"
      expect(response).to be_success
    end
    it "access to route for sorting reader desc" do
      get :index, :sort => "reader", :direction => "desc"
      expect(response).to be_success
    end
  end

  describe "POST #mark_as_read without signing in" do
    before(:each) do
      @article_ids = [4, 8, 12, 16, 20]
    end
    it "access to route" do
      post :mark_as_read, :article_ids => @article_ids
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #mark_as_read with signing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [4, 8, 12, 16, 20]
      @expect_result = [true, true, true, true, true]
    end
    it "access to route and check result" do
      post :mark_as_read, :article_ids => @article_ids
      result = @login_user.user_articles.where(:article_id => @article_ids).pluck(:read_flg)
      expect(result).to match_array @expect_result
    end
  end

  describe "POST #mark_as_read with signing in and invalid article id" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [4, 8, 100]
      @expect_result = [true, true]
    end
    it "access to route and check result" do
      post :mark_as_read, :article_ids => @article_ids
      result = @login_user.user_articles.where(:article_id => @article_ids).pluck(:read_flg)
      expect(result).to match_array @expect_result
    end
  end

  describe "POST #mark_as_unread without signing in" do
    before(:each) do
      @article_ids = [2, 6, 10, 14, 18]
    end
    it "access to route" do
      post :mark_as_unread, :article_ids => @article_ids
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #mark_as_unread with signing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [2, 6, 10, 14, 18]
      @expect_result = [false, false, false, false, false]
    end
    it "access to route and check result" do
      post :mark_as_unread, :article_ids => @article_ids
      result = @login_user.user_articles.where(:article_id => @article_ids).pluck(:read_flg)
      expect(result).to match_array @expect_result
    end
  end

  describe "POST #mark_as_unread with signing in and invalid article id" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [2, 6, 100]
      @expect_result = [false, false]
    end
    it "access to route and check result" do
      post :mark_as_unread, :article_ids => @article_ids
      result = @login_user.user_articles.where(:article_id => @article_ids).pluck(:read_flg)
      expect(result).to match_array @expect_result
    end
  end

  describe "POST #mark_as_favorite without signing in" do
    before(:each) do
      @article_ids = [4, 6, 10, 12, 16]
    end
    it "access to route" do
      post :mark_as_favorite, :article_ids => @article_ids
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #mark_as_favorite with signin in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [4, 6, 10, 12, 16]
      @expect_result = [true, true, true, true, true]
    end
    it "access to route and check result" do
      post :mark_as_favorite, :article_ids => @article_ids
      result = @login_user.user_articles.where(:article_id => @article_ids).pluck(:favorite_flg)
      expect(result).to match_array @expect_result
    end
  end

  describe "POST #mark_as_favorite with signin in and invalid article id" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [4, 6, 100]
      @expect_result = [true, true]
    end
    it "access to route and check result" do
      post :mark_as_favorite, :article_ids => @article_ids
      result = @login_user.user_articles.where(:article_id => @article_ids).pluck(:favorite_flg)
      expect(result).to match_array @expect_result
    end
  end

  describe "POST #mark_off_favorite without signing in" do
    before(:each) do
      @article_ids = [2, 8, 14, 20, 26]
    end
    it "access to route" do
      post :mark_off_favorite, :article_ids => @article_ids
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #mark_off_favorite with signing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [2, 8, 14, 20, 26]
      @expect_result = [false, false, false, false, false]
    end
    it "access to route and check result" do
      post :mark_off_favorite, :article_ids => @article_ids
      result = @login_user.user_articles.where(:article_id => @article_ids).pluck(:favorite_flg)
      expect(result).to match_array @expect_result
    end
  end

  describe "POST #mark_off_favorite with signing in and invalid article id" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [2, 8, 100]
      @expect_result = [false, false]
    end
    it "access to route and check result" do
      post :mark_off_favorite, :article_ids => @article_ids
      result = @login_user.user_articles.where(:article_id => @article_ids).pluck(:favorite_flg)
      expect(result).to match_array @expect_result
    end
  end

  describe "POST #delete_article without signing in" do
    before(:each) do
      @article_ids = [2, 4, 6, 8, 10]
    end
    it "access to route" do
      post :delete_article, :article_ids => @article_ids
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #delete_article with singing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [2, 4, 6, 8, 10]
    end
    it "access to route and check result" do
      post :delete_article, :article_ids => @article_ids
      result = @login_user.user_articles.where(:article_id => @article_ids)
      expect(result).to eq([])
    end
  end

  describe "POST #delete_summary without singing in" do
    before(:each) do
      @article_ids = [4, 10, 15, 16, 41]
    end
    it "access to route" do
      post :delete_summary, :article_ids => @article_ids
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #delete_summary with singing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [4, 10, 15, 16, 41]
    end
    it "access to route and check result" do
      post :delete_summary, :article_ids => @article_ids
      result = @login_user.summaries.where(:article_id => @article_ids)
      expect(result).to eq([])
    end
  end

  describe "POST #delete_summary with singing in and invalid article id" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [4, 10, 15, 100]
    end
    it "access to route and check result" do
      post :delete_summary, :article_ids => @article_ids
      result = @login_user.summaries.where(:article_id => @article_ids)
      expect(result).to eq([])
    end
  end

  describe "POST #clip without signing in" do
    before(:each) do
      @article_ids = [92, 94, 96, 98, 100]
    end
    it "access to route" do
      post :clip, :article_ids => @article_ids
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #clip with singing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [92, 94, 96, 98]
    end
    it "access to route and check result" do
      post :clip, :article_ids => @article_ids
      result = @login_user.user_articles.where(:article_id => @article_ids)
      expect(result).not_to eq([])
    end
  end

  describe "POST #clip with singing in and invalid article id" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @article_ids = [92, 100]
    end
    it "access to route and check result" do
      post :clip, :article_ids => @article_ids
      result = @login_user.user_articles.where(:article_id => @article_ids)
      expect(result).not_to eq([])
    end
  end

  describe "POST #follow without signing in" do
    before(:each) do
      @following_user_id = 32
    end
    it "access to route" do
      post :follow, :follow_user_id => @following_user_id
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "POST #follow with signing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @following_user_id = 32
    end
    it "access to route without no parameters" do
      post :follow, :follow_user_id => @following_user_id
      result = FavoriteUser.where(:user_id => @login_user.id, :favorite_user_id => @following_user_id)
      expect(result).not_to be_nil
    end
  end

  describe "POST #follow with signing in and invalid user id" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @following_user_id = 1000
    end
    it "access to route without no parameters" do
      post :follow, :follow_user_id => @following_user_id
      expect(response).to render_template(:file => "#{Rails.root}/public/404.html")
    end
  end

  describe "POST #unfollow" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @unfollow_user_id = 31
    end
    it "access to route without no parameters" do
      post :unfollow, :unfollow_user_id => @unfollow_user_id
      result = FavoriteUser.where(:user_id => @login_user.id, :favorite_user_id => @unfollow_user_id)
      expect(result).to eq([])
    end
  end

  describe "POST #unfollow and invalid user id" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @login_user = User.find_by_id(1)
      @unfollow_user_id = 1000
    end
    it "access to route without no parameters" do
      post :unfollow, :unfollow_user_id => @unfollow_user_id
      expect(response).to render_template(:file => "#{Rails.root}/public/404.html")
    end
  end

  describe "GET #tag without signing in" do
    it "access to route" do
      get :tag, :tag => "test"
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "GET #tag with signing in" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12346"
      @login_user = User.find_by_id(2)
      @expect_articles = [6, 20, 48]
      @expect_tags = [["activerecord", "rails", "ruby", "sqlite3", "heroku"], 
                      ["gotolove", "wei", "ruby", "nokogiri"],
                      ["ruby", "rails", "activerecord"]]
    end
    it "access to route with unregistered tag" do
      get :tag, :tag => "unknown"
      expect(response).to be_success
    end
    it "access to route with valid tag" do
      get :tag, :tag => "ruby"
      expect(response).to be_success
    end
    it "access to route with valid tag and check result" do
      get :tag, :tag => "ruby"
      result = assigns[:articles].pluck(:id)
      expect(result).to match_array @expect_articles
    end
    it "access to route with valid tag and check tags" do
      get :tag, :tag => "ruby"
      result = assigns[:tags]
      expect(result).to match_array @expect_tags
    end
    it "acess to route with valid tag and sort that is Oldest" do
      get :tag, :tag => "ruby", :sort => "registered", :direction => "asc"
      expect(response).to be_success
    end
    it "acess to route with valid tag and sort that is Newest" do
      get :tag, :tag => "ruby", :sort => "registered", :direction => "desc"
      expect(response).to be_success
    end
    it "acess to route with valid tag and sort that is Least summarized" do
      get :tag, :tag => "ruby", :sort => "summaries", :direction => "asc"
      expect(response).to be_success
    end
    it "acess to route with valid tag and sort that is Most summarized" do
      get :tag, :tag => "ruby", :sort => "summaries", :direction => "desc"
      expect(response).to be_success
    end
    it "acess to route with valid tag and sort that is Least read" do
      get :tag, :tag => "ruby", :sort => "reader", :direction => "asc"
      expect(response).to be_success
    end
    it "acess to route with valid tag and sort that is Most read" do
      get :tag, :tag => "ruby", :sort => "reader", :direction => "desc"
      expect(response).to be_success
    end
    it "access to route with valid tag and page" do
      get :tag, :tag => "ruby", :page => 1
      expect(response).to be_success
    end
    it "access to route with valid tag and over page" do
      get :tag, :tag => "ruby", :page => 2
      expect(response).to be_success
    end
  end

end
