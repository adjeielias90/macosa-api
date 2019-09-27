class Api::V1::SupplierOrdersController < ApplicationController
  before_action :set_supplier_order, only: [:show, :update]#, :destroy]
  before_action :authenticate_request!

  # GET /supplier_orders
  def index
    @supplier_orders = SupplierOrder.all.order(created_at: :DESC).page params[:page]
    # Custom Pagination
    @per_page = 10
    total_records = SupplierOrder.count
    # @orders = Order.all.page params[:page]

    if (total_records % @per_page) == 0
      total_pages = total_records/@per_page
    else
      total_pages = (total_records/@per_page) + 1
    end
    @meta = { total_pages: total_pages, total_records: total_records }

    render json: @supplier_orders, meta: @meta, status: :ok
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
      @supplier_order.generate_order_number!
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
      params.require(:supplier_order).permit(:order_id, :manufacturer_id, :supplier_no, :order_no, :order_date, :amount, :comments, :eta, :description, :delivered )
    end
end