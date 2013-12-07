require 'spec_helper'

#TODO ちょっと全体的に未完成なので修正する

describe SummaryController do
  fixtures(:all)

  describe "GET #edit without signing in" do
    it "access to route without no parameters" do
      get :edit, :article_id => "1"
      expect(response).to redirect_to :controller => 'consumer',:action => 'index'
    end
  end

  describe "GET #edit signing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
    end
    it "edit" do
      get :edit, :article_id => "1"
      response.should be_success
    end
    it "edit with known article" do
      get :edit, :article_id => "9999999"
      #response.should 404
    end
  end

  describe "POST #edit_complete without signing in" do
    it "access to route without no parameters" do
      post :edit_complete, :article_id => "1"
      expect(response).to redirect_to :controller => 'consumer',:action => 'index'
    end
  end

  describe "POST #edit_complete signing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
    end
    it "access to route without no parameters" do
      post :edit_complete, :article_id => "2"
      response.should be_success
    end
  end

  describe "POST #delete without signing in" do
    it "access to route without no parameters" do
      post :delete, :article_id => "1"
      expect(response).to redirect_to :controller => 'consumer',:action => 'index'
    end
  end

  describe "POST #delete signing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
    end
    it "access to route without no parameters" do
      post :delete, :article_id => "2"
      response.should be_success
    end
  end
end
