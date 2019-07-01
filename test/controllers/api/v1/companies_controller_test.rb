require 'test_helper'

class Api::V1::CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_v1_company = api_v1_companies(:one)
  end

  test "should get index" do
    get api_v1_companies_url, as: :json
    assert_response :success
  end

  test "should create api_v1_company" do
    assert_difference('Api::V1::Company.count') do
      post api_v1_companies_url, params: { api_v1_company: { address: @api_v1_company.address, background: @api_v1_company.background, company_type_id: @api_v1_company.company_type_id, email: @api_v1_company.email, name: @api_v1_company.name, owner_id: @api_v1_company.owner_id, phone: @api_v1_company.phone, website: @api_v1_company.website } }, as: :json
    end

    assert_response 201
  end

  test "should show api_v1_company" do
    get api_v1_company_url(@api_v1_company), as: :json
    assert_response :success
  end

  test "should update api_v1_company" do
    patch api_v1_company_url(@api_v1_company), params: { api_v1_company: { address: @api_v1_company.address, background: @api_v1_company.background, company_type_id: @api_v1_company.company_type_id, email: @api_v1_company.email, name: @api_v1_company.name, owner_id: @api_v1_company.owner_id, phone: @api_v1_company.phone, website: @api_v1_company.website } }, as: :json
    assert_response 200
  end

  test "should destroy api_v1_company" do
    assert_difference('Api::V1::Company.count', -1) do
      delete api_v1_company_url(@api_v1_company), as: :json
    end

    assert_response 204
  end
end
