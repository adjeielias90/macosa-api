class OrdersWorker < Api::V1::OrdersController
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(order)
    @order = Order.new(order)
    # @order.generate_order_number!
    # @order.set_date!
    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end


  # def order_params
  #   params.require(:order).permit(:id, :order_no, :date, :description, :amount, :profit, :customer_id, :account_manager_id, :user_id, :currency_id, business_unit_orders_attributes: [ :id, :business_unit_id, :amount, :date, :order_id], manufacturer_orders_attributes: [:id, :manufacturer_id, :amount, :date, :order_id])
  # end
end