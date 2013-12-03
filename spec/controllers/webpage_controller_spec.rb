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
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "add_confirm with unknown article" do
      post :add_confirm, :url => "http://www.yahoo.co.jp/", :add_flag => "true"
      response.should be_success
      assigns[:title].should == "Yahoo! JAPAN"
      assigns[:top_rated_tags].should == nil
      assigns[:recent_tags].should ==  ["１２３４５６７８９０", "１２３４５６７８９５", "１２３４５６７８９４", "１２３４５６７８９３", "１２３４５６７８９２", "１２３４５６７８９１", "Rails", "SQL", "Ruby", "ruby"]
      assigns[:set_tags].should == []
      assigns[:summary_num].should == nil
      assigns[:reader_num] == nil
      assigns[:article_id] == nil
    end
    it "add_confirm with known article no set tag" do
      post :add_confirm, :url => "http://zasshi.news.yahoo.co.jp/article?a=20130930-00010000-bjournal-bus_all", :add_flag => "true"
      response.should be_success
      assigns[:title].should == "auのKDDI、あきれた二枚舌営業〜購入時に虚偽説明、強いクレームには特別に補償対応 （Business Journal） - Yahoo!ニュース"
      assigns[:top_rated_tags].should == []
      assigns[:recent_tags].should ==  ["１２３４５６７８９０", "１２３４５６７８９５", "１２３４５６７８９４", "１２３４５６７８９３", "１２３４５６７８９２", "１２３４５６７８９１", "Rails", "SQL", "Ruby", "ruby"]
      assigns[:set_tags].should == []
      assigns[:summary_num].should == 0
      assigns[:reader_num] == 0
      assigns[:article_id] == "1"
    end
    it "add_confirm with known article set tag" do
      post :add_confirm, :url => "http://qiita.com/toyama0919/items/3e165e41232266edbb23", :add_flag => "true"
      response.should be_success
      assigns[:title].should == "rubyのgeocoderの使い方 - Qiita [キータ]"
      assigns[:top_rated_tags].should == ["ge"]
      assigns[:recent_tags].should ==  ["１２３４５６７８９０", "１２３４５６７８９５", "１２３４５６７８９４", "１２３４５６７８９３", "１２３４５６７８９２", "１２３４５６７８９１", "Rails", "SQL", "Ruby", "ruby"]
      assigns[:set_tags].should == ["ge"]
      assigns[:summary_num].should == 3
      assigns[:reader_num].should == 1
      assigns[:article_id].should == 44
    end
  end
end
