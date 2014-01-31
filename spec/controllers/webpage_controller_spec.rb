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
      post :add_confirm, :url => "http://www.yahoo.co.jp/", :add_flag => "true"
      expect(response).to be_success
      expect(assigns[:title]).to "Yahoo! JAPAN"
      expect(assigns[:top_rated_tags]).to nil
      expect(assigns[:recent_tags]).to  ["１２３４５６７８９０", "１２３４５６７８９５", "１２３４５６７８９４", "１２３４５６７８９３", "１２３４５６７８９２", "１２３４５６７８９１", "Rails", "SQL", "Ruby", "ruby"]
      expect(assigns[:set_tags]).to []
      expect(assigns[:summary_num]).to nil
      expect(assigns[:reader_num]).to nil
      expect(assigns[:article_id]).to nil
    end
    it "add_confirm with known article no set tag" do
      post :add_confirm, :url => "http://zasshi.news.yahoo.co.jp/article?a=20130930-00010000-bjournal-bus_all", :add_flag => "true"
      expect(response).to be_success
      expect(assigns[:title]).to "auのKDDI、あきれた二枚舌営業〜購入時に虚偽説明、強いクレームには特別に補償対応 (Business Journal) - Yahoo!ニュース"
      expect(assigns[:top_rated_tags]).to []
      expect(assigns[:recent_tags]).to  ["１２３４５６７８９０", "１２３４５６７８９５", "１２３４５６７８９４", "１２３４５６７８９３", "１２３４５６７８９２", "１２３４５６７８９１", "Rails", "SQL", "Ruby", "ruby"]
      expect(assigns[:set_tags]).to []
      expect(assigns[:summary_num]).to 0
      expect(assigns[:reader_num]).to 0
      #assigns[:article_id] == "1"
    end
    it "add_confirm with known article set tag" do
      post :add_confirm, :url => "http://qiita.com/toyama0919/items/3e165e41232266edbb23", :add_flag => "true"
      expect(response).to be_success
      expect(assigns[:top_rated_tags]).to ["ge"]
      expect(assigns[:recent_tags]).to  ["１２３４５６７８９０", "１２３４５６７８９５", "１２３４５６７８９４", "１２３４５６７８９３", "１２３４５６７８９２", "１２３４５６７８９１", "Rails", "SQL", "Ruby", "ruby"]
      expect(assigns[:set_tags]).to ["ge"]
      expect(assigns[:summary_num]).to 3
      expect(assigns[:reader_num]).to 1
      expect(assigns[:article_id]).to 44
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
    it "add complete add flag blank" do
      post :add_complete, :url => "http://zasshi.news.yahoo.co.jp/article?a=20130930-00010000-bjournal-bus_all", :add_flag => ""
      expect(response).to redirect_to :controller => 'mypage',:action => 'index'
    end
    it "add complete no tag" do
      post :add_complete, :url => "http://zasshi.news.yahoo.co.jp/article?a=20130930-00010000-bjournal-bus_all", :add_flag => "true"
      #expect(response).to be_success
      expect(assigns[:prof_image]).to "/images/medium/no_image.png"
      expect(assigns[:url]).to "http://zasshi.news.yahoo.co.jp/article?a=20130930-00010000-bjournal-bus_all"
      #assigns[:article_id]).to 1
      expect(assigns[:title]).to "auのKDDI、あきれた二枚舌営業〜購入時に虚偽説明、強いクレームには特別に補償対応 （Business Journal） - Yahoo!ニュース"
      expect(assigns[:contents_preview]).to "\n米アップルのiPhone 5s/5cの発売、およびNTTドコモのiPhone商戦への参入で話題沸騰の携帯電話業界。その陰で、KDDI(au)の不誠実な消費者対応が大きな問題となる可能性がある。その行為は、「詐欺的」と言われても仕方ないもので、消費者は今後、auの動向に注目していく必要がある。\nKDDIは今年5月21日、不当景品類及び不当表示防止法の規定に基づく措置命令を消費者庁から受けた。その概"
      expect(assigns[:thumbnail]).to "http://amd.c.yimg.jp/im_sigg8XxvdH3npMkCXSmvXM9SvQ---x153-y200-q90/amd/20130930-00010000-bjournal-000-1-view.jpg"
      expect(assigns[:category]).to "other"
      expect(assigns[:tags]).to []
      expect(assigns[:msg]).to "Completed."
    end
    it "add complete with tag" do
      post :add_complete, :url => "http://zasshi.news.yahoo.co.jp/article?a=20130930-00010000-bjournal-bus_all", :add_flag => "true",
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
      #expect(response).to be_success
      expect(assigns[:prof_image]).to "/images/medium/no_image.png"
      expect(assigns[:url]).to "http://zasshi.news.yahoo.co.jp/article?a=20130930-00010000-bjournal-bus_all"
      #assigns[:article_id]).to 1
      expect(assigns[:title]).to "auのKDDI、あきれた二枚舌営業〜購入時に虚偽説明、強いクレームには特別に補償対応 （Business Journal） - Yahoo!ニュース"
      expect(assigns[:contents_preview]).to "\n米アップルのiPhone 5s/5cの発売、およびNTTドコモのiPhone商戦への参入で話題沸騰の携帯電話業界。その陰で、KDDI(au)の不誠実な消費者対応が大きな問題となる可能性がある。その行為は、「詐欺的」と言われても仕方ないもので、消費者は今後、auの動向に注目していく必要がある。\nKDDIは今年5月21日、不当景品類及び不当表示防止法の規定に基づく措置命令を消費者庁から受けた。その概"
      expect(assigns[:thumbnail]).to "http://amd.c.yimg.jp/im_sigg8XxvdH3npMkCXSmvXM9SvQ---x153-y200-q90/amd/20130930-00010000-bjournal-000-1-view.jpg"
      expect(assigns[:category]).to "other"
      expect(assigns[:tags].to ["tag1", "tag2", "tag3", "tag4", "tag5", "tag6", "tag7", "tag8", "tag9", "tag10"]
      expect(assigns[:msg]).to "Completed."
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
=begin
    it "OK" do
      post :delete, :article_id => "20"
      expect(response).to be_success
      expect(response.body).to eq "OK"
    end
    it "NG" do
      post :delete, :article_id => "21"
      expect(response).to be_success
      expect(response.body).to eq "NG"
    end
=end
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
