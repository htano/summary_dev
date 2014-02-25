require 'spec_helper'

describe RedirectorController do

  describe "GET 'original_page'" do
    it "returns http success" do
      get 'original_page'
      response.should be_success
    end
  end

end
