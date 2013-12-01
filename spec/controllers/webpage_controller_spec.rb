require 'spec_helper'

describe WebpageController do
  #fixtures(:all)

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
    it "access to route without no parameters" do
      post :add_confirm, :name => "http://www.yahoo.co.jp/", :add_flag => "true"
      p @title
    end
  end
end
