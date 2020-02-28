require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "anonymous index" do
    get :index
    assert_redirected_to user_session_path
   end

  test "AdminUser index" do
    sign_in users(:admin_user)
    get :index
    assert_response :success
    assert_select "a[href=#{cities_path}]"
    assert_select "a[href=#{admin_users_path}]"
    assert_select "a[href=#{franquia_users_path}]"
   end

  test "FranquiaUser index" do
    sign_in users(:franquia_1)
    get :index
    assert_response :success
    assert_select "a[href=#{cities_path}]", false
    assert_select "a[href=#{admin_users_path}]", false
    assert_select "a[href=#{franquia_users_path}]", false
   end
end
