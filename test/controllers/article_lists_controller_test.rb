require 'test_helper'

class ArticleListsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get listByTag" do
    get :listByTag
    assert_response :success
  end

end
