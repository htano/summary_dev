require 'spec_helper'

describe HotentryController do
  fixtures(:all)

  describe "GET #index" do
    it "access to index" do
      get :index
      expect(response).to(be_success)
    end
    it "access to normal" do
      get :normal
      expect(response).to(
        redirect_to(:controller => 'hotentry',:action => 'index')
      )
    end
    it "access to small" do
      get :small
      expect(response).to(
        redirect_to(:controller => 'hotentry',:action => 'index')
      )
    end
    it "access to large" do
      get :large
      expect(response).to(
        redirect_to(:controller => 'hotentry',:action => 'index')
      )
    end
  end
end
