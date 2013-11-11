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
      follower_uid = 
        FavoriteUser.where(:favorite_user_id => 1).limit(DISPLAY_USER_NUM).pluck(:user_id)
      @summary_followers_with_no_number = 
        User.where(:id => follower_uid)

      follower_uid = 
        FavoriteUser.where(:favorite_user_id => 1).limit(DISPLAY_USER_NUM).offset(DISPLAY_USER_NUM).pluck(:user_id)
      @summary_followers_with_number = 
        User.where(:id => follower_uid)
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
      expect(assigns[:followers]).to eq(@summary_followers_with_no_number)
    end
    it "get followers with number" do
      get :followers, :number => 1
      expect(assigns[:followers]).to eq(@summary_followers_with_number)
    end
    it "get followers with invalid number" do
      get :followers, :number => 2
      expect(assigns[:followers]).to eq([])
    end
    it "get followers with minus number" do
      get :followers, :number => -1
      expect(assigns[:followers]).to eq(@summary_followers_with_no_number)
    end
  end

end
