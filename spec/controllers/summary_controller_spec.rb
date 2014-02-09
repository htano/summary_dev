require 'spec_helper'

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
      session[:openid_url] = "oauth://facebook/12350"
    end
    it "edit content" do
      get :edit, :article_id => "1"
      expect(response).to be_success
      expect(assigns[:url]).to "http://zasshi.news.yahoo.co.jp/article?a=20130930-00010000-bjournal-bus_all"
      expect(assigns[:title]).to "auのKDDI、あきれた二枚舌営業〜購入時に虚偽説明、強いクレームには特別に補償対応 （Business Journal） - Yahoo!ニュース"
      expect(assigns[:summary_num]).to 1
      expect(assigns[:content]).to "10年以上auの携帯電話を使っている筆者は昨年12月、auのiPhone 5に切り替えた。補償するという意味合いが強かった。KDDIは公式的には消費者への補償はしないと説明していたのに、実際の現場では強くクレームを付ける消費者には補償対応している。まさに「二枚舌営業」なのである。今度は取材として広報部に「二枚舌ではないか」と聞くと、広報部長は「公式見解と個別の顧客対応は違う」と説明、「二枚舌営業」を自ら認めた。大株主のトヨタには特別対応?。これらの疑問についてKDDI広報に聞くと、トヨタへは「特別対応」しているという。トヨタはKDDIの大株主であり、業務用携帯はauを使っているからであろう。"
      expect(assigns[:content_num]).to 299
    end
    it "edit no content" do
      get :edit, :article_id => "69"
      expect(response).to be_success
      expect(assigns[:url]).to "http://www.amazon.com/gp/product/B000NQRE9Q/ref=s9_qpp_gw_d99_g74_ir03?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=center-5&pf_rd_r=1JS0Y4VZMR0PEDPPW98G&pf_rd_t=101&pf_rd_p=1630072322&pf_rd_i=507846"
      expect(assigns[:title]).to "Amazon.com: Indiana Jones: The Complete Adventures [Blu-ray]"
      expect(assigns[:summary_num]).to 1
      expect(assigns[:content]).to ""
      expect(assigns[:content_num]).to 0
    end
     it "edit with unknown article" do
      get :edit, :article_id => "9999999"
      expect(response.response_code).to eq 404
    end
  end

  describe "POST #edit_complete without signing in" do
    it "access to route without no parameters" do
      post :edit_complete, :article_id => "1"
      expect(response).to redirect_to :controller => 'consumer',:action => 'index'
    end
  end

#TODO ちょっと全体的に未完成なので修正する
  describe "POST #edit_complete signing in" do
    before(:each) do
      session[:openid_url] = "oauth://facebook/12350"
    end
     it "edit_complete with unknown article" do
      get :edit_complete, :article_id => "9999999"
      expect(response.response_code).to eq 404
    end
     it "edit_complete with known article" do
      post :edit_complete, :article_id => "1", :content => "要約ですよ"
      summary = Summary.find_by_user_id_and_article_id("6", "1")
      expect(summary.content).to eq "要約ですよ"
      expect(response).to redirect_to :controller => 'summary_lists',:action => 'index'
    end
     it "edit_complete no summary article" do
      post :edit_complete, :article_id => "2", :content => "要約ですの"
      summary = Summary.find_by_user_id_and_article_id("6", "2")
      expect(summary.content).to eq "要約ですの"
      expect(response).to redirect_to :controller => 'summary_lists',:action => 'index'
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
      session[:openid_url] = "oauth://facebook/12350"
    end
    it "access to route without no parameters" do
      post :delete, :article_id => "1"
      expect(response).to redirect_to :controller => 'mypage',:action => 'index'
    end
    it "access to route without no parameters" do
      post :delete, :article_id => "999"
      expect(response).to redirect_to :controller => 'mypage',:action => 'index'
    end
  end
end
