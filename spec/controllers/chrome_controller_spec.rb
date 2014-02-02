require 'spec_helper'

describe ChromeController do
  fixtures(:all)

  describe "GET #get_background_info without signin" do
    it "get_background_info with url" do
      get :get_background_info, :url => "http://www.yahoo.co.jp/"
      expect(response).to be_success
      @expected = {:summary_num  => 0, :user_article_id => ""}.to_json
      expect(response.body).to eq @expected
    end
  end

  describe "GET #get_background_info with signin" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "get_background_info with url not registered" do
      get :get_background_info, :url => "http://www.yahoo.co.jp/"
      expect(response).to be_success
      @expected = {:summary_num  => 0, :user_article_id => ""}.to_json
      expect(response.body).to eq @expected
    end
    it "get_background_info with url already registered" do
      get :get_background_info, :url => "http://wired.jp/2012/10/29/softbank-sprint/"
      expect(response).to be_success
      @expected = {:summary_num  => 0, :user_article_id => 53}.to_json
      expect(response.body).to eq @expected
    end
  end

  describe "GET #get_summary_list" do
    it "get_summary_list no one registered" do
      get :get_summary_list, :url => "http://www.yahoo.co.jp/"
      expect(response).to be_success
      expect(response.body).to eq "null"
    end
    it "get_summary_list already registered & no summary" do
      get :get_summary_list, :url => "http://internet.watch.impress.co.jp/docs/news/20131003_618057.html"
      expect(response).to be_success
      expect(response.body).to eq "[]"
    end
    it "get_summary_list already registered & some summary" do
      get :get_summary_list, :url => "http://wired.jp/2012/10/29/softbank-sprint/"
      expect(response).to be_success
      @expected = [{
        :id => 22,
        :content => "ソフトバンクとスプリントが直面する先進国通信市場の課題。ソフトバンクのスプリント買収の発表から2週間あまりが過ぎ、過熱した報道も一段落した。別記事「ソフトバンク、米スプリントの買収を正式発表 世界3位の移動体通信事業者へ」より。ソフトバンクが全米第3位の携帯電話会社スプリント・ネクステル(以下スプリント)の買収を発表してから、2週間あまりが過ぎた。一方、スプリントは、先進国の通信事業者の課題を、抱え込んでいるように見える。こうしたリスクを負いながら、ソフトバンクとスプリントは、どこへ向かうのか。トークイベント緊急開催のご案内。  「ソフトバンクによるスプリント買収は業界地図をどう変えるのか」。",
        :user_id => 6,
        :article_id => 20,
        :created_at => "2013-10-08T08:41:06.556+09:00",
        :updated_at => "2013-10-08T08:41:06.556+09:00",
        :good_summaries_count =>0
      }].to_json
      expect(response.body).to eq @expected
    end
  end

  describe "GET #get_recommend_tag" do
    it "get_recommend_tag unuse url" do
      get :get_recommend_tag, :url => "aaa"
      expect(response).to be_success
      expect(response.body).to eq ""
    end
    it "get_recommend_tag to tag" do
      get :get_recommend_tag, :url => "http://www.yahoo.co.jp/"
      expect(response).to be_success
      expect(response.body).to eq ""
    end
    it "get_recommend_tag some tag" do
      get :get_recommend_tag, :url => "http://wired.jp/2012/10/29/softbank-sprint/"
      expect(response).to be_success
      expect(response.body).to eq "[\"ruby\", \"activerecord\", \"rails\", \"エンタメ\", \"heroku\", \"sqlite3\"]"
    end
  end

  describe "GET #get_recent_tag without signin" do
    it "access to route without no parameters" do
      get :get_recent_tag
      expect(response).to be_success
      expect(response.body).to eq ""
    end
  end

  describe "GET #get_recent_tag with signin no register user" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12347"
    end
    it "get_recent_tag no register user" do
      get :get_recent_tag
      expect(response).to be_success
      expect(response.body).to eq ""
    end
  end

  describe "GET #get_recent_tag with signin register user" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "get_recent_tag register user" do
      get :get_recent_tag
      expect(response).to be_success
      expect(response.body).to eq "[\"１２３４５６７８９０\", \"１２３４５６７８９５\", \"１２３４５６７８９４\", \"１２３４５６７８９３\", \"１２３４５６７８９２\", \"１２３４５６７８９１\", \"Rails\", \"SQL\", \"Ruby\", \"ruby\"]"
    end
  end

  describe "GET #get_set_tag without singin" do
    it "get_set_tag" do
      get :get_set_tag
      expect(response).to be_success
      expect(response.body).to eq ""
    end
  end

  describe "GET #get_set_tag with singin" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "get_set_tag with singin" do
      get :get_set_tag, :url => "http://www.yahoo.co.jp/"
      expect(response).to be_success
      expect(response.body).to eq ""
    end
    it "get_set_tag with singin" do
      get :get_set_tag, :url => "http://wired.jp/2012/10/29/softbank-sprint/"
      expect(response).to be_success
      expect(response.body).to eq "[\"エンタメ\"]"
    end
  end

  describe "GET #get_set_tag with singin" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12347"
    end
    it "get_set_tag with singin" do
      get :get_set_tag, :url => "http://wired.jp/2012/10/29/softbank-sprint/"
      expect(response.body).to eq ""
    end
  end

  #ここまで
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