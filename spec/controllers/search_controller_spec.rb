require 'spec_helper'

describe SearchController do

  describe "GET #index" do
    it "index" do
      get :index
      assigns[:target].should == 1
      assigns[:type].should == 1
      assigns[:sort].should == 1
      assigns[:category].should == 0
    end
  end

  describe "GET #search_article" do
    it "search_article type 1 sort 1" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "1"
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 2 sort 1" do
      get :search_article, :searchtext => "", :type => "2" , :sort => "1"
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 3 sort 1" do
      get :search_article, :searchtext => "", :type => "3" , :sort => "1"
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 4 sort 1" do
      get :search_article, :searchtext => "", :type => "4" , :sort => "1"
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 1 sort 2" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "2"
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 1 sort 3" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "3"
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 1 sort 4" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "4"
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
  end

  describe "GET #search_user" do
    it "search_user sort 1" do
      get :search_user, :searchtext => "", :sort => "1"
      response.response_code.should == 200
    end
    it "search_user sort 2" do
      get :search_user, :searchtext => "", :sort => "2"
      response.response_code.should == 200
    end
    it "search_user sort 3" do
      get :search_user, :searchtext => "", :sort => "3"
      response.response_code.should == 302
    end
  end
end