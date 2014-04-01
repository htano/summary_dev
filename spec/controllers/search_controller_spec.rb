require 'spec_helper'

describe SearchController do

  describe "GET #index" do
    it "index" do
      get :index
      expect(assigns[:searchtext]).to eq nil
      expect(assigns[:target]).to eq 1
      expect(assigns[:type]).to eq 1
      expect(assigns[:sort]).to eq 1
      expect(assigns[:category]).to eq 0
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq nil
      expect(assigns[:type_text]).to eq nil
      expect(assigns[:sort_menu_title]).to eq nil
      #expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
  end

  describe "GET #search_article" do
    it "search_article searchtext nil" do
      get :search_article, :searchtext => ""
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "1"
      expect(assigns[:sort]).to eq "1"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq "内容"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 1 sort 1" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "1"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "1"
      expect(assigns[:sort]).to eq "1"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq "内容"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 1 sort 2" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "2"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "1"
      expect(assigns[:sort]).to eq "2"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq "内容"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 1 sort 3" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "3"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "1"
      expect(assigns[:sort]).to eq "3"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq "内容"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 1 sort 4" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "4"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "1"
      expect(assigns[:sort]).to eq "4"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq "内容"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 2 sort 1" do
      get :search_article, :searchtext => "", :type => "2" , :sort => "1"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "2"
      expect(assigns[:sort]).to eq "1"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq "タグ"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 2 sort 2" do
      get :search_article, :searchtext => "", :type => "2" , :sort => "2"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "2"
      expect(assigns[:sort]).to eq "2"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq "タグ"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 2 sort 3" do
      get :search_article, :searchtext => "", :type => "2" , :sort => "3"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "2"
      expect(assigns[:sort]).to eq "3"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq "タグ"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 2 sort 4" do
      get :search_article, :searchtext => "", :type => "2" , :sort => "4"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "2"
      expect(assigns[:sort]).to eq "4"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq "タグ"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 3 sort 1" do
      get :search_article, :searchtext => "", :type => "3" , :sort => "1"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "3"
      expect(assigns[:sort]).to eq "1"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq  "ドメイン"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 3 sort 2" do
      get :search_article, :searchtext => "", :type => "3" , :sort => "2"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "3"
      expect(assigns[:sort]).to eq "2"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq  "ドメイン"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 3 sort 3" do
      get :search_article, :searchtext => "", :type => "3" , :sort => "3"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "3"
      expect(assigns[:sort]).to eq "3"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq  "ドメイン"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 3 sort 4" do
      get :search_article, :searchtext => "", :type => "3" , :sort => "4"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "3"
      expect(assigns[:sort]).to eq "4"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq nil
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq "ドメイン"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 4 sort 1" do
      get :search_article, :searchtext => "", :type => "4" , :sort => "1"
      expect(assigns[:searchtext]).to eq ""
      expect(assigns[:target]).to eq "1"
      expect(assigns[:type]).to eq "4"
      expect(assigns[:sort]).to eq "1"
      expect(assigns[:category]).to eq "0"
      expect(assigns[:articles]).to eq []
      expect(assigns[:article_num]).to eq 0
      expect(assigns[:type_text]).to eq nil
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
  end

  describe "GET #search_user without signin" do
    it "search_user sort 1" do
      get :search_user, :searchtext => "", :sort => "1"
      expect(response.response_code).to eq 200
    end
    it "search_user sort 2" do
      get :search_user, :searchtext => "", :sort => "2"
      expect(response.response_code).to eq 200
    end
    it "search_user sort 3" do
      get :search_user, :searchtext => "", :sort => "3"
      expect(response.response_code).to eq 302
    end
  end


  describe "GET #search_user with signin" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "search_user sort 1" do
      get :search_user, :searchtext => "", :sort => "1"
      expect(response.response_code).to eq 200
    end
    it "search_user sort 2" do
      get :search_user, :searchtext => "", :sort => "2"
      expect(response.response_code).to eq 200
    end
    it "search_user sort 3" do
      get :search_user, :searchtext => "", :sort => "3"
      expect(response.response_code).to eq 302
    end
  end

  describe "GET #search_user_article with signin" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "search_user_article sort 1" do
      get :search_user_article, :sort => "1", :article_id => "1"
      expect(assigns[:article_title]).to eq "auのKDDI、あきれた二枚舌営業〜購入時に虚偽説明、強いクレームには特別に補償対応 （Business Journal） - Yahoo!ニュース"
      expect(assigns[:article_id]).to eq "1"
      expect(assigns[:target]).to eq "3"
      expect(assigns[:sort]).to eq "1"
      expect(assigns[:user_num]).to eq 0
      expect(response.response_code).to eq 200
    end
    it "search_user_article sort 2" do
      get :search_user_article, :sort => "2", :article_id => "1"
      expect(assigns[:article_title]).to eq "auのKDDI、あきれた二枚舌営業〜購入時に虚偽説明、強いクレームには特別に補償対応 （Business Journal） - Yahoo!ニュース"
      expect(assigns[:article_id]).to eq "1"
      expect(assigns[:target]).to eq "3"
      expect(assigns[:sort]).to eq "2"
      expect(assigns[:user_num]).to eq 0
      expect(response.response_code).to eq 200
    end
    it "search_user_article sort 3" do
      get :search_user_article, :sort => "3", :article_id => "1"
      expect(response.response_code).to eq 302
    end
  end
end