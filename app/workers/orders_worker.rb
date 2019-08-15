class OrdersWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(order)
    @order = Order.new(order)
    @order.generate_order_number!
    # @order.set_date!
    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end
end