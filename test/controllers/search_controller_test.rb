require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get search_by_tag" do
    get :search_by_tag
    assert_response :success
  end

  test "should get search_by_content" do
    get :search_by_content
    assert_response :success
  end

  test "should get search_by_title" do
    get :search_by_title
    assert_response :success
  end

end
