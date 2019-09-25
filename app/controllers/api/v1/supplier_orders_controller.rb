class Api::V1::SupplierOrdersController < ApplicationController
  before_action :set_supplier_order, only: [:show, :update]#, :destroy]
  before_action :authenticate_request!

  # GET /supplier_orders
  def index
    @supplier_orders = SupplierOrder.all

    render json: @supplier_orders
  end

  # GET /supplier_orders/1
  def show
    render json: @supplier_order
  end

  # POST /supplier_orders
  def create
    @supplier_order = SupplierOrder.new(supplier_order_params)
    @order = Order.find(params[:order_id])
    @supplier_order.order_no = @order.order_no
    if @supplier_order.save
      @supplier.generate_order_number!
      render json: @supplier_order, status: :created
    else
      render json: @supplier_order.errors, status: :unprocessable_entity
    end


    # def set_order_number
    #   @order = Order.find(params[:order_id])
    #   @supplier_order.order_no = @order.order_no
    # end
  end

  # PATCH/PUT /supplier_orders/1
  def update
    if @supplier_order.update(supplier_order_params)
      render json: @supplier_order
    else
      render json: @supplier_order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /supplier_orders/1
  def destroy
    # @supplier_order.destroy
    @supplier_order = SupplierOrder.with_deleted.find(params[:id])
    if params[:type] == 'normal'
      @supplier_order.destroy
      render json: {success: "Supplier Order deleted and archived"}, status: :ok
    elsif params[:type] == 'forever'
      @supplier_order.really_destroy!
      render json: {success: "Supplier Order permanently deleted"}, status: :ok
    elsif params[:type] == 'undelete'
      @supplier_order.restore
      render json: {success: "Supplier Order restored"}, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier_order
      @supplier_order = SupplierOrder.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def supplier_order_params
      params.require(:supplier_order).permit(:order_id, :supplier_id, :supplier_no, :order_no, :order_date, :amount, :eta, :delivered)
    end
end
