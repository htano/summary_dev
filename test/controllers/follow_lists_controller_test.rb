require 'test_helper'

class FollowListsControllerTest < ActionController::TestCase
  test "should get followers" do
    get :followers
    assert_response :success
  end

  test "should get following" do
    get :following
    assert_response :success
  end

  test "should get suggestion" do
    get :suggestion
    assert_response :success
  end

end
