require 'spec_helper'

describe WebpageController do
  fixtures(:all)

  describe "GET #add without signing in" do
    it "access to route without no parameters" do
      get :add
      expect(response).to redirect_to :controller => 'consumer',:action => 'index'
    end
  end

  describe "GET #add with signing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
    end
    it "access to route without no parameters" do
      get :add
      result_val = @user_id
      result_val.should == nil
    end
    it "access to route without no parameters" do
      get :add, :name => "1"
      @user_id == "1"
    end
  end

  describe "POST #add_confirm without signing in" do
    it "access to route without no parameters" do
      post :add_confirm
      expect(response).to redirect_to :controller => 'consumer',:action => 'index'
    end
  end

  describe "POST #add_confirm with signing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
    end
    it "add_confirm with unknown article" do
      post :add_confirm, :url => "http://www.yahoo.co.jp/", :add_flag => "true"
      response.should be_success
      assigns[:title].should == "Yahoo! JAPAN"
      assigns[:top_rated_tags].should == nil
      assigns[:recent_tags].should eq ["ge", "MVC", "マーケティング", "Rails", "sqlite3", "Ruby"]
      assigns[:set_tags].should eq []
      assigns[:summary_num].should == nil
      assigns[:reader_num] == nil
      assigns[:article_id] == nil
    end
  end
end
