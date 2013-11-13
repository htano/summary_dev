require 'spec_helper'

describe FollowListsController do
  fixtures(:all)

  DISPLAY_USER_NUM = 20

  describe "GET #followers without signing in" do
    it "access to route successfully" do
      get :followers, :name => "foo"
      expect(response).to be_success
    end
    it "access to route without param" do
      get :followers
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "GET #followers with signing in" do
    before(:each) do
=begin
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        :provider => 'twitter',
        :uid => '12345'
        })
=end
      session[:openid_url] = "oauth://twitter/12345"
      @first_display_followers = 
        [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]
      @second_display_followers = 
        [22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
    end

    it "access to route successfully" do
      get :followers
      expect(response).to be_success
    end
    it "get user name successfully" do
      get :followers
      expect(assigns[:user_name]).to eq("summary")
    end
    it "get followers with no number" do
      get :followers
      ids = assigns[:followers].pluck(:id)
      expect(ids).to match_array(@first_display_followers)
    end
    it "get followers with number" do
      get :followers, :number => 1
      ids = assigns[:followers].pluck(:id)
      expect(ids).to match_array(@second_display_followers)
    end
    it "get followers with invalid number" do
      get :followers, :number => 2
      expect(assigns[:followers]).to eq([])
    end
    it "get followers with minus number" do
      get :followers, :number => -1
      ids = assigns[:followers].pluck(:id)
      expect(ids).to match_array(@first_display_followers)
    end
  end

  describe "GET #following without signing in" do
    it "access to route successfully" do
      get :following, :name => "foo"
      expect(response).to be_success
    end
    it "access to route without param" do
      get :following
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end

  describe "GET #following with signing in" do
    before(:each) do
      session[:openid_url] = "oauth://twitter/12345"
      @first_display_followings = 
        [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]
      @second_display_followings = 
        [22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
    end
    it "access to route successfully" do
      get :following
      expect(response).to be_success
    end
    it "get user name successfully" do
      get :following
      expect(assigns[:user_name]).to eq("summary")
    end
    it "get following with no number" do
      get :following
      ids = assigns[:following_users].pluck(:id)
      expect(ids).to match_array(@first_display_followings)
    end
    it "get following with number" do
      get :following, :number => 1
      ids = assigns[:following_users].pluck(:id)
      expect(ids).to match_array(@second_display_followings)
    end
    it "get following with invalid number" do
      get :following, :number => 2
      expect(assigns[:following_users]).to eq([])
    end
    it "get following with minus number" do
      get :following, :number => -1
      ids = assigns[:following_users].pluck(:id)
      expect(ids).to match_array(@first_display_followings)
    end
  end

  describe "GET #suggestion without signing in" do
    it "access to route successfully" do
      get :suggestion, :name => "foo"
      expect(response).to be_success
    end
    it "access to route successfully" do
      get :suggestion, :name => "foo"
      expect(@candidate_users).to be_false
    end
    it "access to route without param" do
      get :suggestion
      expect(response).to redirect_to :controller => 'consumer', 
                                      :action => 'index'
    end
  end


end
