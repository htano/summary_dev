require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  test "should get profile" do
    get :profile
    assert_response :success
  end

  test "should get profile_edit" do
    get :profile_edit
    assert_response :success
  end

  test "should get profile_edit_complete" do
    get :profile_edit_complete
    assert_response :success
  end

  test "should get email" do
    get :email
    assert_response :success
  end

  test "should get email_edit" do
    get :email_edit
    assert_response :success
  end

  test "should get email_edit_complete" do
    get :email_edit_complete
    assert_response :success
  end

  test "should get account" do
    get :account
    assert_response :success
  end

end
