require 'test_helper'

class BusinessUnitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business_unit = business_units(:one)
  end

  test "should get index" do
    get business_units_url, as: :json
    assert_response :success
  end

  test "should create business_unit" do
    assert_difference('BusinessUnit.count') do
      post business_units_url, params: { business_unit: { name: @business_unit.name } }, as: :json
    end

    assert_response 201
  end

  test "should show business_unit" do
    get business_unit_url(@business_unit), as: :json
    assert_response :success
  end

  test "should update business_unit" do
    patch business_unit_url(@business_unit), params: { business_unit: { name: @business_unit.name } }, as: :json
    assert_response 200
  end

  test "should destroy business_unit" do
    assert_difference('BusinessUnit.count', -1) do
      delete business_unit_url(@business_unit), as: :json
    end

    assert_response 204
  end
end
