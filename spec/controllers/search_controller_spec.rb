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
      expect(assigns[:type_text]).to eq "タイトル＆本文"
      expect(assigns[:sort_menu_title]).to eq nil
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 1 sort 1" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "1"
=begin
      expect(assigns[:searchtext]).to nil
      expect(assigns[:target]).to "1"
      expect(assigns[:type]).to "1"
      expect(assigns[:sort]).to "1"
      expect(assigns[:category]).to "0"
      expect(assigns[:articles]).to nil
      expect(assigns[:article_num]).to 0
      expect(assigns[:type_text]).to "タイトル＆本文"
      expect(assigns[:sort_menu_title]).to nil
=end
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 2 sort 1" do
      get :search_article, :searchtext => "", :type => "2" , :sort => "1"
=begin
      expect(assigns[:searchtext]).to nil
      expect(assigns[:target]).to "1"
      expect(assigns[:type]).to "1"
      expect(assigns[:sort]).to "1"
      expect(assigns[:category]).to "0"
      expect(assigns[:articles]).to nil
      expect(assigns[:article_num]).to 0
      expect(assigns[:type_text]).to "タイトル＆本文"
      expect(assigns[:sort_menu_title]).to nil
=end
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 3 sort 1" do
      get :search_article, :searchtext => "", :type => "3" , :sort => "1"
=begin
      expect(assigns[:searchtext]).to nil
      expect(assigns[:target]).to "1"
      expect(assigns[:type]).to "1"
      expect(assigns[:sort]).to "1"
      expect(assigns[:category]).to "0"
      expect(assigns[:articles]).to nil
      expect(assigns[:article_num]).to 0
      expect(assigns[:type_text]).to "タイトル＆本文"
      expect(assigns[:sort_menu_title]).to nil
=end
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 4 sort 1" do
      get :search_article, :searchtext => "", :type => "4" , :sort => "1"
=begin
      expect(assigns[:searchtext]).to nil
      expect(assigns[:target]).to "1"
      expect(assigns[:type]).to "1"
      expect(assigns[:sort]).to "1"
      expect(assigns[:category]).to "0"
      expect(assigns[:articles]).to nil
      expect(assigns[:article_num]).to 0
      expect(assigns[:type_text]).to "タイトル＆本文"
      expect(assigns[:sort_menu_title]).to nil
=end
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 1 sort 2" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "2"
=begin
      expect(assigns[:searchtext]).to nil
      expect(assigns[:target]).to "1"
      expect(assigns[:type]).to "1"
      expect(assigns[:sort]).to "1"
      expect(assigns[:category]).to "0"
      expect(assigns[:articles]).to nil
      expect(assigns[:article_num]).to 0
      expect(assigns[:type_text]).to "タイトル＆本文"
      expect(assigns[:sort_menu_title]).to nil
=end
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 1 sort 3" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "3"
=begin
      expect(assigns[:searchtext]).to nil
      expect(assigns[:target]).to "1"
      expect(assigns[:type]).to "1"
      expect(assigns[:sort]).to "1"
      expect(assigns[:category]).to "0"
      expect(assigns[:articles]).to nil
      expect(assigns[:article_num]).to 0
      expect(assigns[:type_text]).to "タイトル＆本文"
      expect(assigns[:sort_menu_title]).to nil
=end
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
    it "search_article type 1 sort 4" do
      get :search_article, :searchtext => "", :type => "1" , :sort => "4"
=begin
      expect(assigns[:searchtext]).to nil
      expect(assigns[:target]).to "1"
      expect(assigns[:type]).to "1"
      expect(assigns[:sort]).to "1"
      expect(assigns[:category]).to "0"
      expect(assigns[:articles]).to nil
      expect(assigns[:article_num]).to 0
      expect(assigns[:type_text]).to "タイトル＆本文"
      expect(assigns[:sort_menu_title]).to nil
=end
      expect(response).to redirect_to :controller => 'search',:action => 'index'
    end
  end

  describe "GET #search_user" do
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
end