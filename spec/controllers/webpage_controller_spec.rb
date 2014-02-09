require 'spec_helper'

describe WebpageController do
  fixtures(:all)
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
      post :add_confirm, :url => "http://www.yahoo.co.jp/"
      expect(response).to be_success
      expect(assigns[:title]).to eq "Yahoo! JAPAN"
      expect(assigns[:top_rated_tags]).to eq nil
      #expect(assigns[:recent_tags]).to  eq ["１２３４５６７８９０", "１２３４５６７８９５", "１２３４５６７８９４", "１２３４５６７８９３", "１２３４５６７８９２", "１２３４５６７８９１", "Rails", "SQL", "Ruby", "ruby"]
      expect(assigns[:set_tags]).to eq []
      expect(assigns[:summary_num]).to eq nil
      expect(assigns[:reader_num]).to eq nil
      expect(assigns[:article_id]).to eq nil
    end
    it "add_confirm with known article no set tag" do
      post :add_confirm, :url => "http://d.hatena.ne.jp/yutakikuchi/20130606/1370475477"
      expect(response).to be_success
      expect(assigns[:title]).to eq "一日も早く起業したい人が「やっておくこと、知っておくべきこと」読了 - Yuta.Kikuchiの日記"
      expect(assigns[:top_rated_tags]).to eq ["wordpress"]
      #expect(assigns[:recent_tags]).to eq ["１２３４５６７８９０", "１２３４５６７８９５", "１２３４５６７８９４", "１２３４５６７８９３", "１２３４５６７８９２", "１２３４５６７８９１", "Rails", "SQL", "Ruby", "ruby"]
      expect(assigns[:set_tags]).to eq []
      expect(assigns[:summary_num]).to eq 0
      expect(assigns[:reader_num]).to eq 0
      expect(assigns[:article_id]).to eq 18
    end
    it "add_confirm with known article set tag" do
      post :add_confirm, :url => "http://qiita.com/toyama0919/items/3e165e41232266edbb23"
      expect(response).to be_success
      expect(assigns[:top_rated_tags]).to eq ["ge"]
      #expect(assigns[:recent_tags]).to  eq ["１２３４５６７８９０", "１２３４５６７８９５", "１２３４５６７８９４", "１２３４５６７８９３", "１２３４５６７８９２", "１２３４５６７８９１", "Rails", "SQL", "Ruby", "ruby"]
      expect(assigns[:set_tags]).to eq ["ge"]
      expect(assigns[:summary_num]).to eq 3
      expect(assigns[:reader_num]).to eq 1
      expect(assigns[:article_id]).to eq 44
    end
  end

  describe "POST #add_complete without signing in" do
    it "access to route without no parameters" do
      post :add_complete
      expect(response).to redirect_to :controller => 'consumer',:action => 'index'
    end
  end

  describe "POST #add_complete with signing in" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "add complete wrong url" do
      post :add_complete, :url => "fdsfadsfa", :add_flag => "true"
      expect(flash[:error]).not_to be_nil
    end
    it "add complete no tag flag blank" do
      post :add_complete, :url => "http://d.hatena.ne.jp/yutakikuchi/20130606/1370475477", :add_flag => ""
      expect(response).to redirect_to :controller => 'mypage',:action => 'index'
      expect(assigns[:prof_image]).to eq "/images/medium/no_image.png"
      expect(assigns[:url]).to eq "http://d.hatena.ne.jp/yutakikuchi/20130606/1370475477"
      expect(flash[:success]).not_to be_nil
    end
    it "add complete no tag" do
      post :add_complete, :url => "http://d.hatena.ne.jp/yutakikuchi/20130606/1370475477", :add_flag => "true"
      expect(response).to redirect_to :controller => 'mypage',:action => 'index'
      expect(assigns[:prof_image]).to eq "/images/medium/no_image.png"
      expect(assigns[:url]).to eq "http://d.hatena.ne.jp/yutakikuchi/20130606/1370475477"
      expect(flash[:success]).not_to be_nil
    end
    it "add complete with tag" do
      post :add_complete, :url => "http://d.hatena.ne.jp/yutakikuchi/20130606/1370475477", :add_flag => "true",
       :tag_text_1 =>"tag1",
       :tag_text_2 =>"tag2",
       :tag_text_3 =>"tag3",
       :tag_text_4 =>"tag4",
       :tag_text_5 =>"tag5",
       :tag_text_6 =>"tag6",
       :tag_text_7 =>"tag7",
       :tag_text_8 =>"tag8",
       :tag_text_9 =>"tag9",
       :tag_text_10 =>"tag10"
      expect(response).to redirect_to :controller => 'mypage',:action => 'index'
      expect(assigns[:prof_image]).to eq "/images/medium/no_image.png"
      expect(assigns[:url]).to eq "http://d.hatena.ne.jp/yutakikuchi/20130606/1370475477"
      expect(flash[:success]).not_to be_nil
    end
  end

  describe "POST #delete without signing in" do
    it "access to route without no parameters" do
      post :delete
      expect(response).to redirect_to :controller => 'consumer',:action => 'index'
    end
  end

  describe "POST #delete signing in" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "delete" do
      post :delete, :article_id => "20"
    end
  end

  describe "POST #mark_as_read without signing in" do
    it "access to route without no parameters" do
      post :mark_as_read
      expect(response).to redirect_to :controller => 'consumer',:action => 'index'
    end
  end

  describe "POST #mark_as_read signing in" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12354"
    end
    it "mark unread" do
      post :mark_as_read, :article_id => "20"
      expect(response).to be_success
      expect(response.body).to eq "mark_as_unread"
    end
    it "mark read" do
      post :mark_as_read, :article_id => "22"
      expect(response).to be_success
      expect(response.body).to eq "mark_as_read"
    end
    it "NG" do
      post :mark_as_read, :article_id => "21"
      expect(response).to be_success
      expect(response.body).to eq "NG"
    end
  end
end
