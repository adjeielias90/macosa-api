require 'test_helper'

class SupplierOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supplier_order = supplier_orders(:one)
  end

  test "should get index" do
    get supplier_orders_url, as: :json
    assert_response :success
  end

  test "should create supplier_order" do
    assert_difference('SupplierOrder.count') do
      post supplier_orders_url, params: { supplier_order: { amount: @supplier_order.amount, delivered: @supplier_order.delivered, eta: @supplier_order.eta, order_date: @supplier_order.order_date, order_id: @supplier_order.order_id, order_no: @supplier_order.order_no, supplier_id: @supplier_order.supplier_id, supplier_no: @supplier_order.supplier_no } }, as: :json
    end

    assert_response 201
  end

  test "should show supplier_order" do
    get supplier_order_url(@supplier_order), as: :json
    assert_response :success
  end

  test "should update supplier_order" do
    patch supplier_order_url(@supplier_order), params: { supplier_order: { amount: @supplier_order.amount, delivered: @supplier_order.delivered, eta: @supplier_order.eta, order_date: @supplier_order.order_date, order_id: @supplier_order.order_id, order_no: @supplier_order.order_no, supplier_id: @supplier_order.supplier_id, supplier_no: @supplier_order.supplier_no } }, as: :json
    assert_response 200
  end

  test "should destroy supplier_order" do
    assert_difference('SupplierOrder.count', -1) do
      delete supplier_order_url(@supplier_order), as: :json
    end

    assert_response 204
  end
end
