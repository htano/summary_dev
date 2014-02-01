require 'spec_helper'

describe ChromeController do
  fixtures(:all)

  describe "GET #get_background_info" do
    it "get_background_info with url" do
      get :get_background_info, :url => "http://www.yahoo.co.jp/"
    end
  end

  describe "GET #get_summary_list" do
    it "access to route without no parameters" do
      get :get_summary_list
    end
  end


  describe "GET #get_recommend_tag" do
    it "access to route without no parameters" do
      get :get_recommend_tag
    end
  end

  describe "GET #get_recent_tag without signin" do
    it "access to route without no parameters" do
      get :get_recent_tag
    end
  end

  describe "GET #get_recent_tag with signin" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "access to route without no parameters" do
      get :get_recent_tag
    end
  end

  describe "GET #get_set_tag" do
    it "access to route without no parameters" do
      get :get_set_tag
    end
  end

  describe "GET #get_article_data without signin" do
    it "access to route without no parameters" do
      get :get_article_data
    end
  end

  describe "GET #get_article_data with signin" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "access to route without no parameters" do
      get :get_article_data
    end
  end

  describe "GET #get_login_user_id without singin" do
    it "access to route without no parameters" do
      get :get_login_user_id
    end
  end

  describe "GET #get_login_user_id with singin" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "access to route without no parameters" do
      get :get_login_user_id
    end
  end

  describe "GET #add without singin" do
    it "access to route without no parameters" do
      get :add
    end
  end

  describe "GET #add with singin" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "access to route without no parameters" do
      get :add
    end
  end

  describe "GET #edit_tag without signin" do
    it "access to route without no parameters" do
      get :edit_tag
    end
  end

  describe "GET #edit_tag with signin" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "access to route without no parameters" do
      get :edit_tag
    end
  end
end