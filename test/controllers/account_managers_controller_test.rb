require 'test_helper'

class AccountManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_manager = account_managers(:one)
  end

  test "should get index" do
    get account_managers_url, as: :json
    assert_response :success
  end

  test "should create account_manager" do
    assert_difference('AccountManager.count') do
      post account_managers_url, params: { account_manager: { full_name: @account_manager.full_name } }, as: :json
    end

    assert_response 201
  end

  test "should show account_manager" do
    get account_manager_url(@account_manager), as: :json
    assert_response :success
  end

  test "should update account_manager" do
    patch account_manager_url(@account_manager), params: { account_manager: { full_name: @account_manager.full_name } }, as: :json
    assert_response 200
  end

  test "should destroy account_manager" do
    assert_difference('AccountManager.count', -1) do
      delete account_manager_url(@account_manager), as: :json
    end

    assert_response 204
  end
end
