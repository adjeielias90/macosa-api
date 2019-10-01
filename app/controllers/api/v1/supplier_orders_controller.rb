class Api::V1::SupplierOrdersController < Api::V1::BaseController
  before_action :set_supplier_order, only: [:show, :update]#, :destroy]
  before_action :authenticate_request!

  # GET /supplier_orders
  def index

    if params.present?
      # Test condition here to find interval scope
        # if 'to' and 'from' present,
        # Call the interval scope with:
        # Order.interval('from_datetime_obj: 2015-07-09', 'to_datetime_obj: 2015-07-09')
      #
      # if params[:to].present? && params[:from].present?
        # @orders = Order.filter(params.slice(:customer_id, :order_date, :user_id, :account_manager_id)).interval(params[:to], params[:from])
      # else
      if params.has_key?(:page)
        # Only allow a trusted parameter "white list" through.
        # @orders = Order.filter(params.slice(:customer_id, :order_date, :user_id, :account_manager_id, :currency_id)).order(created_at: :DESC).page params[:page]
        @supplier_orders = SupplierOrder.filter(params.slice(:manufacturer_id)).order(created_at: :DESC).page params[:page]
      else
        # @orders = Order.filter(params.slice(:customer_id, :order_date, :user_id, :account_manager_id, :currency_id)).order(created_at: :DESC)
        @supplier_orders = SupplierOrder.filter(params.slice(:manufacturer_id)).order(created_at: :DESC)
      end
    else
      @supplier_orders = Order.all.order(created_at: :DESC)
    end

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
    @order = Order.find_by(id: params[:order_id])
    @supplier_order.order_no = @order.order_no
    if @supplier_order.save
      @supplier_order.generate_order_number!
      @supplier_order.set_default_delivered!
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

    # A list of the param names that can be used for filtering the Supplier Order list
    def filtering_params(params)
      params.slice(:manufacturer_id)
    end
end

# filtering patams
# manufacturer_id